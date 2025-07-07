sub main(args as dynamic)
    screen = createObject("roSGScreen")
    port = createObject("roMessagePort")
    screen.setMessagePort(port)
    m.roInput = CreateObject("roInput")
    m.roInput.SetMessagePort(port)
    ' ? "lanch : "args
    scene = screen.createScene("MainScene")
    
    deeplink = getDeepLinks(args)
    scene.deeplink = deeplink
    'scene.callFunc("setDeepLink", deeplink)
    ' ? "deeplink : "; scene.deeplink
    screen.show()
    ' vscode_rdb_on_device_component_entry
    while true
        msg = wait(0, port)
        if type(msg) = "roSGScreenEvent" and msg.isScreenClosed()
            return
        else if type(msg) = "roSGNodeEvent"
            return
        else if type(msg) = "roInputEvent"and msg.isInput() then
            ? "msg : "msg.getData()
            deeplink = getDeepLinks(msg.GetInfo())
            ' scene.setField("deepLink", deeplink)
            scene.deeplink = deeplink
            info = msg.GetInfo()
        end if
    end while
end sub


function getDeepLinks(args) as object
    deeplink = { }
   
    if args.contentid <> invalid and args.mediaType <> invalid
        deeplink = {
            id: args.contentId
            type: args.mediaType
        }
    end if

    return deeplink
end function