sub init()
    m.posterPrimary = m.top.findNode("posterPrimary")
    m.posterSecondary = m.top.findNode("posterSecondary")
    m.animationShowSecondary = m.top.findNode("animationShowSecondary")
    m.animationShowPrimary = m.top.findNode("animationShowPrimary")
    'anytime the animations change, we want to know about it
    m.animationShowSecondary.observeFieldScoped("state", "onanimationShowSecondaryStateChange")
    m.animationShowPrimary.observeFieldScoped("state", "onanimationShowPrimaryStateChange")
    m.top.observeField("content", "onContentSet")
    m.top.observeField("pauseScroller", "OnPauseScroller")
    m.currentMediaItemIndex = 0
    m.mediaItems = []
end sub

sub OnPauseScroller(event as object)
    isPaused = event.getData()
    if isPaused then
        onHide()
    else
        onShow()
    end if
end sub

sub onShow()
    ' Resume or start animation if needed
    if m.animationShowPrimary <> invalid
        m.animationShowPrimary.control = "start"
    end if
    if m.animationShowSecondary <> invalid
        m.animationShowSecondary.control = "start"
    end if
end sub

sub onHide()
    ' Pause or stop the animation when navigating away
    if m.animationShowPrimary <> invalid
        m.animationShowPrimary.control = "stop"
    end if

    if m.animationShowSecondary <> invalid
        m.animationShowSecondary.control = "stop"
    end if
end sub

sub onContentSet(event as object)
    imageData = event.getData()

    for i = 0 to imageData.count() - 1

        for i = 0 to imageData.count() - 1
            if (i mod 2 = 0)
                timeOut = 6
            else
                timeOut = 10
            end if
            item = {
                uri: imageData[i],
                timeoutSeconds: timeOut
            }
            m.mediaItems.push(item)
        end for

    end for

    'show the first poster
    showImageAtIndex(m.posterSecondary, 1)
    showImageAtIndex(m.posterPrimary, 0)
    m.animationShowSecondary.delay = m.mediaItems[m.currentMediaItemIndex].timeoutSeconds
    m.animationShowSecondary.control = "start"
end sub

function showImageAtIndex(poster, mediaItemIndex as integer)
    if mediaItemIndex > m.mediaItems.count() - 1
        mediaItemIndex = 0 
    end if
    mediaItem = m.mediaItems[mediaItemIndex]
    poster.uri = mediaItem.uri
    m.currentMediaItemIndex = mediaItemIndex
end function

sub onanimationShowSecondaryStateChange()
    if m.animationShowSecondary.state = "stopped"
        showImageAtIndex(m.posterPrimary, m.currentMediaItemIndex + 1)
        m.animationShowPrimary.delay = m.mediaItems[m.currentMediaItemIndex].timeoutSeconds
        m.animationShowPrimary.control = "start"
        ? "yash"
    end if
end sub

sub onanimationShowPrimaryStateChange()
    if m.animationShowPrimary.state = "stopped"
        showImageAtIndex(m.posterSecondary, m.currentMediaItemIndex + 1)
        m.animationShowSecondary.delay = m.mediaItems[m.currentMediaItemIndex].timeoutSeconds
        m.animationShowSecondary.control = "start"
        ? "satish"
    end if
end sub
