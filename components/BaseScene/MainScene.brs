sub init()
    m.loader = m.top.FindNode("busySpinner")
    m.screenContainer = m.top.FindNode("screenContainer")
    ' m.top.observeField("deepLink", "onDeeplink")
    ' m.InputTask = createObject("roSgNode", "inputTask")
    ' m.InputTask.observefield("inputData", "handleInputEvent")
    ' m.InputTask.control = "RUN"
    m.top.backgroundURI = ""
    m.top.backgroundColor = "#171717"
    InitLoader()
    m.screenStack = []
    ShowHomeScreen()
end sub

sub InitLoader()
    m.loader.poster.uri = "pkg:/images/loader.png"
    m.loader.spinInterval = 1
end sub

sub showLoader(isVisible)
    state = "stop"
    if isVisible
        appDimention = getDesignResolution()
        '#TODO: need to remove hardcoded dimention value with dynamic one
        centerx = (appDimention.width - m.loader.poster.bitmapWidth) / 2
        centery = (appDimention.height - m.loader.poster.bitmapWidth) / 2
        m.loader.translation = [centerx, centery]
        state = "start"
    end if
    m.loader.visible = isVisible
    m.loader.control = state
end sub

