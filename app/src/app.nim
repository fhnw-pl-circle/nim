import nigui

when isMainModule:
  nigui.app.init()
  let window = newWindow("hello gui 🚀")

  let label = newLabel("hello gui")
  let button = newButton("close")
  button.onClick = proc(event: ClickEvent) = 
    nigui.app.quit()

  let container = newLayoutContainer(Layout_Vertical)
  window.add(container)

  container.add(label)
  container.add(button)

  window.show()
  nigui.app.run()