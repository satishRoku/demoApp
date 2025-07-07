sub main(args as dynamic)
    screen = createObject("roSGScreen")
    port = createObject("roMessagePort")
    screen.setMessagePort(port)
    ? "lanch : "args
    scene = screen.createScene("MainScene")
    deeplink = getDeepLinks(args)
    scene.deepLink = deeplink
    ? "deeplink : "deeplink
    screen.show()
    ' vscode_rdb_on_device_component_entry
    while true
        msg = wait(0, port)
        if type(msg) = "roSGScreenEvent" and msg.isScreenClosed()
            return
        else if type(msg) = "roSGNodeEvent"
            return
            ' else if type(msg) = "roInput" then
            '     ? "msg : "msg.getData()
            '     deeplink = getDeepLinks(args)
            '     scene.deepLink = deeplink
        end if
    end while
end sub


function getDeepLinks(args) as object
    deeplink = invalid
    if args.contentid <> invalid and args.mediaType <> invalid
        deeplink = {
            id: args.contentId
            type: args.mediaType
        }
    end if

    return deeplink
end function