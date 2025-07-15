sub init()
    m.top.id = "markupgriditem"
    m.itemposter = m.top.findNode("itemPoster")
    m.itemmask = m.top.findNode("itemMask")

    m.title = m.top.findNode("title")
    m.description = m.top.findNode("description")
    m.title.font.size = 30
end sub

sub showcontent()
    itemcontent = m.top.itemContent
    m.itemposter.uri = itemcontent.uri
    m.title.text = itemcontent.title
    m.description.text = itemcontent.description
end sub

' sub showfocus()
'     scale = 1 + (m.top.focusPercent * 0.08)
'     m.itemposter.scale = [scale, scale]
'     m.itemmask.opacity = 0.75 - (m.top.focusPercent * 0.75)
' end sub