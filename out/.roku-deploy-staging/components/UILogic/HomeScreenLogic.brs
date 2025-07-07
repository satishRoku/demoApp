sub ShowHomeScreen()
    showLoader(true)
    m.homeScreen = showScreen("HomeScreen")
    m.homeScreen.id = "homeScreen"
    m.rowList = m.homeScreen.findNode("rowList")
    m.rowList.observeField("content", "buildUI")
    m.rowList.observeField("rowItemSelected", "onItemSelected")
    m.rowList.observeField("rowItemFocused", "onItemFocused")
    m.scrollerView = m.homeScreen.findNode("scrollerView")
    m.homeScreen.content = getStaticApiResponse()
    m.homeScreenData = m.homeScreen.content
    m.homeScreen.observeField("visible", "onHomeScreenVisibleChange")

end sub

sub onHomeScreenVisibleChange(event as object)
    isVisible = event.getData()
    m.scrollerView.pauseScroller = not isVisible
    m.rowList.setFocus(isVisible)
end sub

function getStaticApiResponse() as object
    stringResponse = ReadAsciiFile("pkg:/components/StaticApiResponse/showcaseMoviesUpdated.json")
    if stringResponse = invalid
        print "Error: Unable to read staticApiResponse.json"
        return invalid
    else
        jsonResponse = ParseJson(stringResponse)
        if jsonResponse = invalid
            print "Error: Unable to parse staticApiResponse.json"
            return invalid
        else
            return jsonResponse
        end if
    end if
end function

sub onItemSelected(event as object)
    rowItemSelected = event.getData()
    row = rowItemSelected[0]
    col = rowItemSelected[1]
    item = m.rowList.content.getChild(row).getChild(col)
    if item <> invalid and item.data <> invalid
        m.scrollerView.pauseScroller = true
        ShowDetailsScreen(item.data)
    else
        print "Error: No content available"
    end if

end sub





