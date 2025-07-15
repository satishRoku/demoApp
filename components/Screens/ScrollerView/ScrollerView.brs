sub init()
    m.scrollerGrid = m.top.findNode("scrollerGrid")
    m.scrollTimer = m.top.findNode("scrollTimer")
    m.top.observeField("content", "onContentSet")
    m.mediaItems = []
    m.scrollTimer.observeField("fire", "onScrollTimerFired")
    m.currentIndex = 0

    ' Start auto-scroll
    m.scrollTimer.control = "start"
end sub


sub onContentSet(event as object)
    data = event.getData()
    contentNode = CreateObject("roSGNode", "ContentNode")
    numColumns = 0
    for each item in data
        itemNode = contentNode.createChild("ContentNode")
        itemNode.addFields({ uri: item.eventImage, title: item.name, description: item.description })
        numColumns++
    end for
    m.scrollerGrid.content = contentNode
    m.scrollerGrid.numColumns = numColumns
end sub

sub onScrollTimerFired()
    totalItems = m.scrollerGrid.content.getChildCount()
    if totalItems = 0 return

    m.currentIndex++

    if m.currentIndex >= totalItems
        m.currentIndex = 0 ' loop to start
    end if

    m.scrollerGrid.jumpToItem = m.currentIndex
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if press
        if key = "back" then
            m.scrollTimer.control = "stop"
            m.scrollTimer = invalid
        end if
    end if
    return false
end function