sub init()
    m.top.setFocus(true)
    m.rowList = m.top.findNode("rowList")
    m.scrollerView = m.top.findNode("scrollerView")

    m.videoContainer = m.top.FindNode("videoContainer")
    m.videoPlayer = m.top.FindNode("videoPlayer")
    m.videoPlayerContainer = m.top.FindNode("videoPlayerContainer")
    m.videoTitle = m.top.FindNode("videoTitle")

    m.top.ObserveField("content", "buildUI")
    m.scrollerView.translation = [60, 20]
    initRowList()
    m.images = []
    m.slideWidth = 1650
    m.index = 0
end sub

sub initRowList()
    m.rowList.itemComponentName = "RowListItemTemplate"
    m.rowList.itemSize = [1920, 350]
    m.rowList.rowItemSize = [422, 340]
    m.rowList.rowHeights = [380]

    m.rowList.numRows = 1
    m.rowList.vertFocusAnimationStyle = "floatingFocus"
    m.rowList.rowItemSpacing = [[10, 0]]
    m.rowList.itemSpacing = [10, 10]

    m.rowList.rowSpacings = [10, 10, 10, 10, 10]
    m.rowList.rowLabelOffset = [[0, 5]]
    m.rowList.showRowLabel = [true]
    m.rowList.inheritParentOpacity = false
    m.rowList.translation = [80, 420]
    m.rowList.drawfocusfeedBack = false
end sub


sub setDeeplink(data as object)
    ?"setDeeplink Functionm called"
    m.top.deepLink = data
end sub


sub buildUI(event as object)
    data = event.getData()
    if m.top.getScene().deepLink <> invalid then
        fnDeeplink(data)
    else
        if data <> invalid then
            imagesData = []
            content = CreateObject("roSGNode", "ContentNode")
            for each key in data.keys()
                item = data[key]
                rowNode = content.CreateChild("ContentNode")
                rowNode.title = key
                for each show in item
                    colNode = rowNode.CreateChild("ContentNode")
                    colNode.addFields({ "data": show, "image": show.eventImage })
                    colNode.id = show.id
                    colNode.title = show.name
                    imagesData.push(show.eventImage)
                end for
            end for
            m.scrollerView.content = imagesData
            m.rowList.content = content
            m.rowList.setFocus(true)
        else
            print "Error: No content available"
        end if
    end if
end sub


sub fnDeeplink(content)
    deeplinkData = m.top.deepLink
    if deeplinkData <> invalid and deeplinkData.mediaType <> invalid and deeplinkData.contentId <> invalid then
        handleDeepLink(deeplinkData, content)
    end if
end sub

sub handleDeepLink(deeplinkdata as object, content as object)
    print "Handling deep link: "; deeplinkdata

    contentId = deeplinkdata.contentId
    contentType = deeplinkdata.mediaType ' movie, episode, etc.

    if contentType = "movie" or contentType = "episode"
        showVideoScreen(contentId, content)
    end if
end sub

sub showVideoScreen(contentId as integer, content as object)
    ' content = m.top.content
    data = {}
    for each item in content
        if item.id = contentId then
            data = item
            exit for
        end if
    end for
    ' Add logic to play the movie or show
    createVideoPlayer()
    m.videoPlayer.observeField("state", "onStateChange")
    if m.videoPlayer = invalid then return
    if m.videoPlayer.state = "stopped" or m.videoPlayer.state = "none" then
        m.videoContainer.visible = true
        m.videoPlayer.content = invalid
        videoContent = CreateObject("roSGNode", "ContentNode")
        videoContent.url = data.streamingLink
        m.videoPlayer.content = videoContent
        showVideoPlayer()
        m.videoPlayer.setFocus(true)
        m.videoTitle.text = m.detailsData.name
        m.videoTitle.font.size = 65

        m.videoTitle.visible = true
        m.detailsScreen.showPlayer = true
    end if
end sub

sub createVideoPlayer()
    m.videoPlayer = invalid
    m.videoPlayer = CreateObject("roSGNode", "video")
    m.videoPlayerContainer.appendChild(m.videoPlayer)
end sub

sub showVideoPlayer()
    m.videoPlayer.control = "prebuffer"
    m.videoPlayer.mute = false
    m.videoPlayer.control = "play"
end sub

sub closeVideoPlayer()
    m.videoPlayer.control = "stop"
    m.videoPlayer.control = "none"
    m.bgposter.visible = true
    m.videoPlayerContainer.removeChild(m.videoPlayer)
    m.videoPlayer = invalid
end sub

sub onBackClosePlayer(event as object)
    isBackPressed = event.getData()
    if isBackPressed then
        m.videoPlayer.control = "stop"
        m.videoContainer.visible = false
        m.videoTitle.visible = false
        closeVideoPlayer()
    end if
end sub

' sub OnKeyEvent(key as string, press as boolean) as boolean
'     isHandled = false
'     if press then
'         if key = "back" then
'             m.videoPlayer = m.videoPlayerContainer.getChild(0)
'             if m.videoPlayer <> invalid then
'                 m.top.closePlayer = true
'                 isHandled = true
'             end if
'         end if
'     end if
'     return isHandled
' end sub

sub onStateChange(event as object)
    state = event.getData()
    videoPlayer = event.getRoSGNode()
    if state = "error" then
        m.videoContainer.visible = false
        m.videoTitle.visible = false
        m.buttonList.setFocus(true)
        if videoPlayer.errorMsg <> invalid then
            ? "State : "videoPlayer.errorMsg
        end if
    else if state = "finished" then
        videoPlayer.control = "stop"
        m.videoContainer.visible = false
        m.videoTitle.visible = false
        m.buttonList.setFocus(true)
    end if
end sub

'put code from sample deeplinking

' function manageDeepLink(deeplink as object)
'     if validateDeepLink(deeplink)
'         handleDeepLink()
'     else
'         print "deeplink not validated"
'     end if
' end function

' sub handleInputEvent(msg)
'     ? "in handleInputEvent()"
'     if type(msg) = "roSGNodeEvent" and msg.getField() = "inputData"
'         deeplink = msg.getData()
'         if deeplink <> invalid
'             manageDeepLink(deeplink)
'         end if
'     end if
' end sub

' function validateDeepLink(deeplink as object) as boolean
'     mediatypes = { movie: "movie", episode: "episode", season: "season", series: "series" }
'     if deeplink <> invalid
'         ? "mediaType = "; deeplink.type
'         ? "contentId = "; deeplink.id
'         ? "content= "; m.mediaIndex[deeplink.id]
'         if deeplink.type <> invalid then
'             if mediatypes[deeplink.type] <> invalid
'                 if m.mediaIndex[deeplink.id] <> invalid
'                     if m.mediaIndex[deeplink.id].url <> invalid
'                         return true
'                     else
'                         print "invalid deep link url"
'                     end if
'                 else
'                     print "bad deep link contentId"
'                 end if
'             else
'                 print "unknown media type"
'             end if
'         else
'             print "deeplink.type string is invalid"
'         end if
'     end if
'     return false
' end function