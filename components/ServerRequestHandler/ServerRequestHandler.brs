sub init()
	m.port = createObject("roMessagePort")
	m.top.functionName="getResponse"
	' m.top.functionName="getStaticData"
end sub

function getStaticData()
	Response = ReadAsciiFile("pkg:/components/StaticApiResponse/showcaseMoviesUpdated.json")
	m.top.content = Response
end function


function getResponse()
	requestObject = createUrlObject(m.top.uri)
	requestObject.setMessagePort(m.port)
	requestObject.SetRequest(m.top.requestType)
	headersMap = buildHeader()
	if headersMap <> invalid
		for each header in headersMap
			val = headersMap[header]
			if val <> invalid then
				requestObject.addHeader(header, val)
			end if
		end for
	end if
	if (UCase(m.top.requestType) = UCase("GET")) then
		urlResponse = requestObject.AsyncGetToString()
	else
		if m.top.contentType = "json"
			requestObject.AddHeader("Content-Type", "application/json")
		end if

		requestObject.RetainBodyOnError(true)
		urlResponse = requestObject.AsyncPostFromString(m.top.param)
	end if

	processReqest(urlResponse)
end function

function processReqest(urlResponse)
	if(urlResponse = true)
		while true
			msg = wait(30000, m.port)
			messageType = type(msg)
			if messageType <> "roUrlEvent" or (messageType = "roUrlEvent" and msg.GetResponseCode() < 0)
				print "Task base Network timeout"
				networkError = {}
				networkError.message = "network timeout, please check your network connection"
				networkError.errorCode = -1

				m.top.responseCode = -1
				errorMessageBody = FormatJson(networkError, 1)
				m.top.content = errorMessageBody
				exit while
			else if messageType = "roUrlEvent"
				m.top.responseCode = msg.getResponseCode()
				reason = msg.GetFailureReason()
				m.top.headerInfo = msg.GetResponseHeaders()
				? "msg.Getstring() "msg.Getstring()
				m.top.content = msg.Getstring()
				exit while
			end if
		end while
	else
		' message error
	end if
end function


function createUrlObject(url as string) as dynamic
	urlObject = invalid
	urlObject = CreateObject("roUrlTransfer")

	urlObject.SetUrl(url)

	useSecureConnection = secureConnectionUsed(url)
	'header info
	if useSecureConnection = true
		urlObject.SetCertificatesFile("common:/certs/ca-bundle.crt")
		urlObject.AddHeader("X-Roku-Reserved-Dev-Id", "")
		urlObject.InitClientCertificates()
	end if

	return urlObject
end function

function secureConnectionUsed(urlString as string) as boolean
	secureConnection = false
	urlStringTokens = []

	urlStringObj = CreateObject("roString")
	urlStringObj.SetString(urlString)

	urlStringTokens = urlStringObj.Tokenize("://")

	if urlStringTokens.Count() > 0
		if urlStringTokens[0] = "https"
			secureConnection = true
		end if
	end if

	return secureConnection
end function

function buildHeader()
	device = CreateObject("roDeviceInfo")
	deviceModel = device.GetModel()
	UUID = device.GetChannelClientId()

	appInfo = CreateObject("roAppInfo")
	appVersion = appInfo.GetVersion()
	return {
		"Version": appVersion,
		"Devicetype": "Roku",
		"Deviceid": UUID,
		"Devicetoken": "",
		"Devicemodel": deviceModel
	}
end function