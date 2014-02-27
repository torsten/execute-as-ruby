module.exports =
  activate: ->
    atom.workspaceView.command "execute-as-ruby:execute", => @execute()

  execute: ->
    # This assumes the active pane item is an editor
    editor = atom.workspace.activePaneItem
    cursor = editor.getCursor()
    selection = editor.getSelectedText()

    if not selection
        line = cursor.getCurrentBufferLine()
        result = @runRuby(line)
        editor.moveCursorToEndOfLine()
        editor.insertText(" line: " + result)
    else
        result = @runRuby(selection)
        editor.moveCursorToEndOfLine()
        editor.insertText(" selection: " + result)

  runRuby: (foo) ->
      "___:" + foo.toUpperCase()
