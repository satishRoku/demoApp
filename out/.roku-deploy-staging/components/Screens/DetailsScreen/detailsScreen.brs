sub init()
    m.top.setFocus(true)
    m.bgposter = m.top.FindNode("bgPoster")
    m.title = m.top.FindNode("title")
    m.description = m.top.FindNode("description")
    m.buttonList = m.top.FindNode("buttonList")
    m.videoContainer = m.top.FindNode("videoContainer")
    ' m.videoPlayer = m.top.FindNode("videoPlayer")
    m.bgPlayerContainer = m.top.FindNode("bgPlayerContainer")
    m.videoPlayerContainer = m.top.FindNode("videoPlayerContainer")


    m.videoTitle = m.top.FindNode("videoTitle")
    m.buttonList.ObserveField("itemSelected", "onButtonListSelected")
    m.top.ObserveField("content", "buildUI")

end sub

sub setUpButtonList()
    m.buttonList.textHorizAlign = "center"
    m.buttonList.color = "#ffffff"
    m.buttonList.focusedColor = "#ff0000"
    m.buttonList.vertFocusAnimationStyle = "floatingFocus"
    m.buttonList.font.size = 25
    m.buttonList.focusedFont.size = 32
end sub

sub buildUI(event as object)
    m.data = event.getData()
    if m.data <> invalid then
        m.title.text = m.data.name
        m.title.font.size = 65
        m.description.text = m.data.description
        m.bgposter.loadWidth = 1920
        m.bgposter.loadHeight = 1080
        m.bgposter.width = 1920
        m.bgposter.height = 1080
        m.bgposter.translation = [0, 0]
        m.bgposter.uri = m.data.eventImage
        setUpButtonList()
        m.buttonList.setFocus(true)
        showBGPlayer()
    else
        print "Error: No content available"
    end if
end sub

sub OnKeyEvent(key as string, press as boolean) as boolean
    isHandled = false
    if press then
        if key = "back" then
            m.videoPlayer = m.videoPlayerContainer.getChild(0)
            if m.videoPlayer <> invalid then
                if m.top.showPlayer then
                    m.top.closePlayer = true
                    m.buttonList.setFocus(true)
                    showBGPlayer()
                    isHandled = true
                end if
            else
                m.top.closeScreen = true
                isHandled = true
            end if
        end if
        isHandled = true
    end if
    return isHandled
end sub

sub createBGPlayer()
    m.bgPlayer = CreateObject("roSGNode", "video")
    m.bgPlayerContainer.appendChild(m.bgPlayer)
    m.bgPlayer.ObserveField("state", "onBGPlayerStateChange")
    m.bgPlayer.ObserveField("bufferingStatus", "onBGPlayerBufferingStatus")
end sub

sub showBGPlayer()
    createBGPlayer()
    videoNode = CreateObject("roSGNode", "ContentNode")
    videoNode.url = m.data.trailerLink
    m.bgPlayer.content = videoNode
    m.bgPlayer.control = "prebuffer"
    m.bgPlayer.loop = true
    m.bgPlayer.mute = true
    m.bgPlayer.control = "play"
end sub

sub closeBGPlayer()
    m.bgPlayer.loop = false
    m.bgPlayer.mute = false
    m.bgPlayer.control = "stop"
    m.bgPlayer.control = "none"
    m.bgposter.visible = true
    m.bgPlayerContainer.removeChild(m.bgPlayer)
    m.bgPlayer = invalid
end sub

sub onBGPlayerStateChange(event as object)
    state = event.getData()
    if state = "error" then
        if m.bgPlayer.errorMsg <> invalid then
            ? "State : "m.bgPlayer.errorMsg
        end if
    end if
end sub

sub onBGPlayerBufferingStatus(event as object)
    status = event.getData()
    if status <> invalid and status.prebufferDone then
        m.bgPlayer.visible = true
    end if
end sub

sub onButtonListSelected(event as object)
    buttonIndex = event.getData()
    ' Add logic to play the movie or show
    closeBGPlayer()
    ? "satish......."
end sub


