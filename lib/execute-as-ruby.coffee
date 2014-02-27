{BufferedProcess} = require 'atom'

module.exports =
  activate: ->
    atom.workspaceView.command "execute-as-ruby:execute", => @execute()

  execute: ->
    # This assumes the active pane item is an editor
    editor = atom.workspace.activePaneItem
    cursor = editor.getCursor()
    selection = editor.getSelectedText()

    # for p in atom.packages.getAvailablePackagePaths()
    #     if p.indexOf("/execute-as-ruby") != -1
    #         throw "FAIL"

    insertResult = (result) ->
        editor.moveCursorToEndOfLine()
        editor.insertText(result)

    if not selection
        line = cursor.getCurrentBufferLine()
        result = @runRuby(line, insertResult)
    else
        result = @runRuby(selection, insertResult)

  runRuby: (rubyCode, done) ->
      command = 'ruby'
      args = ['-e', rubyCode]
      output = []
      stdout = (data) ->
          console.log(data)
          output.push(data)
      exit = (code) ->
          console.log("FIN")
          done(output.join(""))
      stderr = (data) ->
          console.error(data)
          output.push(data)
      process = new BufferedProcess({command, args, stdout, stderr, exit})
