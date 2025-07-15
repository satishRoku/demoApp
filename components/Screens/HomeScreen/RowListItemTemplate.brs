' Copyright (c) 2020 Roku, Inc. All rights reserved.
sub Init()
    m.itemPoster = m.top.FindNode("poster")
    m.title = m.top.FindNode("title")
    m.baseRect = m.top.FindNode("baseRect")

    m.itemPoster.observeField("loadStatus", "onImageStateChange")
end sub

sub OnContentSet() ' invoked when item metadata retrieved
    content = m.top.itemContent
    if content = invalid then return
    m.itemPoster.uri = content.image
    m.title.text = content.title
    m.title.font.size = 12

end sub

sub updateDimention()
    ' m.itemPoster.loadWidth = m.top.width
    ' m.itemPoster.width = m.top.width
    ' m.itemPoster.loadHeight = m.top.height
    ' m.itemPoster.height = m.top.height
end sub

sub enlargeItem(event as object)
    focusPercent = event.getData()
    ? "enlargeItem"
    if focusPercent > 0.05
        itemHasFocus = true
        scale = 1 + (m.top.focusPercent * 0.1)
        m.baseRect.scale = [scale, scale]
        m.baseRect.scaleRotateCenter = [m.top.width / 2, m.top.height / 2]
    else
        itemHasFocus = false
    end if
    ' showFocusIndicator(itemHasFocus)
end sub

sub removeEnlaging(event as object)
    rowhasFocus = event.getData()
    if rowhasFocus = false then
        scale = 1
        m.baseRect.scale = [scale, scale]
        m.baseRect.scaleRotateCenter = [m.top.width / 2, m.top.height / 2]
    end if
end sub

sub showFocusedRow(rowhasFocus = true)
    scale = 1
    scale = scale + (m.top.focusPercent * 0.1)
    if rowhasFocus then
        m.baseRect.scale = [scale, scale]
        m.baseRect.scaleRotateCenter = [m.top.width / 2, m.top.height / 2]
    else
        m.baseRect.scale = [scale, scale]
        m.baseRect.scaleRotateCenter = [m.top.width / 2, m.top.height / 2]
    end if
end sub

' sub onImageStateChange(event as object)
'     loadStatus = event.getData()
'     if loadStatus = "failed" then
'         ? "image loading status = "loadStatus
'     else if loadStatus = "loading" then
'         ? "image loading status = "loadStatus
'     else if loadStatus = "ready" then
'         ? "image loading status = "loadStatus
'     end if
' end sub