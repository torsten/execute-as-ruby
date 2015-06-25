{BufferedProcess, CompositeDisposable} = require 'atom'

module.exports =
    activate: ->
        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.commands.add 'atom-workspace',
            'execute-as-ruby:execute': => @execute()

    execute: ->
        if editor = atom.workspace.getActiveTextEditor()
            if not selection = editor.getSelectedText()
                cursor = editor.getLastCursor()
                line = cursor.getCurrentBufferLine()
                @runRuby(line, (result) ->
                    editor.moveToEndOfLine()
                    editor.insertText("\n" + result))
            else
                range = editor.getSelectedBufferRange()
                @runRuby(selection, (result) ->
                    editor.setCursorBufferPosition(range.end)
                    editor.insertText(" " + result))

    packagePath: ->
        packagePath = null
        for p in atom.packages.getAvailablePackagePaths()
            if p.indexOf("/execute-as-ruby") != -1
                packagePath = p
        if not packagePath
            throw "Could not locate package path"
        packagePath

    runRuby: (rubyCode, done) ->
        command = 'ruby'
        args = ['--', @packagePath() + "/lib/helper.rb", rubyCode]
        output = []
        stdout = (data) -> output.push(data)
        exit = (code) -> done(output.join(""))
        stderr = (data) -> output.push(data)
        process = new BufferedProcess({command, args, stdout, stderr, exit})
