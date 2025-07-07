function showScreen(screenName as string)
    if screenName = invalid return invalid
    ' Hide current top scene
    if m.screenStack.count() > 0
        m.screenStack.peek().visible = false
    end if

    ' Create new scene
    newScene = CreateObject("roSGNode", screenName)
    m.screenContainer.appendChild(newScene)
    m.screenStack.push(newScene)
    return newScene
end function

sub closeScreen()
    if m.screenStack.count() > 1
        topScene = m.screenStack.pop()
        m.screenContainer.removeChild(topScene)

        prevScene = m.screenStack.peek()
        if prevScene <> invalid
            prevScene.visible = true
        end if
    else
        print "Can't go back. This is the root scene."
    end if
end sub
