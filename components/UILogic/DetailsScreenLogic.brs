sub ShowDetailsScreen(detailsData as object)
    m.detailsData = detailsData
    showLoader(true)
    m.detailsScreen = invalid
    m.detailsScreen = showScreen("DetailsScreen")
    m.detailsScreen.id = "detailsScreen"
    updateUI()

    m.videoContainer = m.detailsScreen.FindNode("videoContainer")
    m.bgposter = m.detailsScreen.FindNode("bgposter")

    m.videoTitle = m.detailsScreen.FindNode("videoTitle")
    m.buttonList = m.detailsScreen.FindNode("buttonList")

    m.videoPlayerContainer = m.detailsScreen.FindNode("videoPlayerContainer")
    m.detailsScreen.ObserveField("closeScreen", "OnCloseScreen")
    m.buttonList.ObserveField("itemSelected", "onButtonListSelected")
    ' m.buttonList.ObserveField("itemSelected", "onBackClosePlayer")
    m.detailsScreen.ObserveField("closePlayer", "onBackClosePlayer")


end sub

sub updateUI()
    m.detailsScreen.content = m.detailsData
end sub

sub onButtonListSelected(event as object)
    buttonIndex = event.getData()
    ' Add logic to play the movie or show
    ? "harshita......."
    createVideoPlayer()
    m.videoPlayer.observeField("state", "onStateChange")
    if m.videoPlayer = invalid then return
    if m.videoPlayer.state = "stopped" or m.videoPlayer.state = "none" then
        m.videoContainer.visible = true
        videoContent = CreateObject("roSGNode", "ContentNode")
        ' videoContent.streamFormat = "hls"
        if buttonIndex = 0 then
            videoContent.url = m.detailsData.streamingLink
        else
            videoContent.url = m.detailsData.trailerLink
        end if

        m.videoPlayer.content = invalid
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

sub OnCloseScreen(event as object)
    shouldCloseScreen = event.getData()
    if shouldCloseScreen then
        m.bgposter.uri = ""
        closeScreen()
    end if
end sub

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
