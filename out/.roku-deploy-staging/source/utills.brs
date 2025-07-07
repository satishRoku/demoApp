
' "pages/home?auth_token=hvwaaP9ekctDnnNU50HUeqEQ5rrW78DT"

function setScreenResolution()
    resolutionObject = m.top.GetScene().currentDesignResolution
    m.screenWidth = resolutionObject.width
    m.screenHeight = resolutionObject.height
end function

'####################################################
'#######    Registry Functions     ############
'#######        ------------------     ############
'####################################################

function regRead(key, sectionName = "docubay")
    reg = CreateObject("roRegistry")
    sec = CreateObject("roRegistrySection", sectionName)
    secData = invalid
    if sec.Exists(key) then
        secData = sec.read(key)
    end if
    return secData
end function

function regWrite(key, value, sectionName = "docubay")
    sec = CreateObject("roRegistrySection", sectionName)
    key = key.toStr()
    sec.write(key, value)
    sec.flush()
    return true
end function

function regDelete(key, sectionName = "docubay")
    sec = CreateObject("roRegistrySection", sectionName)
    sec.delete(key)
    sec.flush()
    return true
end function

function writeIntoRegistry(key, value)
    m.taskNodeRegistry["key"] = key
    m.taskNodeRegistry["value"] = value
    m.taskNodeRegistry["oprations"] = "write"
end function

'####################################################
'#######    End Registry Functions   ############
'#######        ------------------     ############
'####################################################

function createKeyboard(title = "", message = "", textEntered = "")
    kbdObject = CreateObject("roSGNode", "KeyboardDialog")
    kbdObject.title = title
    kbdObject.message = message
    kbdObject.keyboard.textEditBox.text = textEntered
    if Instr(1, message, "Password") > 0 then
        kbdObject.keyboard.textEditBox.secureMode = true
    else
        kbdObject.keyboard.textEditBox.secureMode = false
    end if
    kbdObject.backgroundUri = "pkg:/locale/default/images/popup_bg.9.png"
    kbdObject.keyboard.textEditBox.cursorPosition = len(textEntered) + 1
    kbdObject.buttons = ["Ok", "Cancel"]
    kbdObject.ObserveField("buttonSelected", "onKeyboardButtonSelected")
    parentNode = m.top.getScene()
    parentNode.Dialog = kbdObject
end function

function onKeyboardButtonSelected(message as object)
    keyboard = message.getRoSGNode()
    optionSelected = message.getData()
    if optionSelected = 0 then
        if Instr(1, UCASE(keyboard.message), UCASE("email")) > 0 then
            m.top.email = keyboard.text
        else if Instr(1, UCASE(keyboard.message), UCASE("Password")) > 0 then
            m.top.password = keyboard.text
        end if
    end if
    keyboard.close = true
end function

function createLayoutGroup(id = "node", layoutDirection = "horiz", itemSpacings = [0], addItemSpacingAfterChild = false)
    node = CreateObject("roSGNode", "LayoutGroup")
    node.id = id
    node.layoutDirection = layoutDirection
    node.itemSpacings = itemSpacings
    node.addItemSpacingAfterChild = addItemSpacingAfterChild
    node.inheritParentOpacity = false
    return node
end function

function createLabelNode(id, color = "#ffffffFF", title = "test Label")
    node = CreateObject("roSGNode", "Label")
    node.id = id
    node.focusable = true
    node.color = color
    node.text = title
    node.inheritParentOpacity = false
    '   node.font = smallQuicksand_BoldFont()
    return node
end function

function createPosterNode(id)
    node = CreateObject("roSGNode", "Poster")
    node.id = id
    return node
end function

function createRectangleNode(id, color, opacity, width, height)
    node = CreateObject("roSGNode", "Rectangle")
    node.id = id
    node.color = color
    node.height = height
    node.width = width
    node.opacity = opacity

    return node
end function

function getDeviceUniqueId()
    di = CreateObject("roDeviceInfo")
    return di.GetChannelClientId()
end function

function getDesignResolution()
    return m.top.getScene().currentDesignResolution
end function