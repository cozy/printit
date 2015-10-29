dateFormat = require './date-format'

module.exports = (options) -> new Logger options

colors =
     blue: ['\x1B[34m', '\x1B[39m']
     cyan: ['\x1B[36m', '\x1B[39m']
     green: ['\x1B[32m', '\x1B[39m']
     magenta: ['\x1B[36m', '\x1B[39m']
     red: ['\x1B[31m', '\x1B[39m']
     yellow: ['\x1B[33m', '\x1B[39m']

levelColors =
    error: colors.red
    debug: colors.green
    warn: colors.yellow
    info: colors.blue

class Logger

    constructor: (@options) ->
        @options ?= {}
        if @options.date and not @options.dateFormat?
            @options.dateFormat = 'YYYY-MM-DD hh:mm:ss:S'

    colorify: (text, color) ->
        "#{color[0]}#{text}#{color[1]}"

    stringify: (text) ->
        if text instanceof Error
            text = text.stack
        else if text instanceof Object
            text = JSON.stringify text
        return text

    getFileAndLine: ->
        stacklist = (new Error()).stack.split('\n').slice(4)
        nodeReg = /at\s+(.*)\s+\((.*):(\d*):(\d*)\)/gi
        browserReg = /at\s+()(.*):(\d*):(\d*)/gi

        firstLineStack = stacklist[0]
        fileAndLineInfos = nodeReg.exec(firstLineStack) or browserReg.exec(firstLineStack)

        filePath = fileAndLineInfos[2].substr(process.cwd().length)
        line = fileAndLineInfos[3]
        return ".#{filePath}:#{line} |"

    format: (level, texts) ->
        texts.unshift(@getFileAndLine()) if process.env.DEBUG

        text = (@stringify text for text in texts).join(" ")

        text = "#{@options.prefix} | #{text}" if @options.prefix?

        if process.env.NODE_ENV isnt 'production'
            level = @colorify level, levelColors[level]

        text = "#{level} - #{text}" if level
        if @options.date
            date = new Date().format @options.dateFormat
            text = "[#{date}] #{text}"
        text

    info: (texts...) ->
        if process.env.DEBUG or process.env.NODE_ENV isnt 'test'
            console.info @format 'info', texts

    warn: (texts...) ->
        if process.env.DEBUG or process.env.NODE_ENV isnt 'test'
            console.warn @format 'warn', texts

    error: (texts...) ->
        if process.env.DEBUG or process.env.NODE_ENV isnt 'test'
            console.error @format 'error', texts

    debug: (texts...) ->
        if process.env.DEBUG
            console.info @format 'debug', texts

    raw: (texts...) ->
        console.log.apply console, texts

    lineBreak: (text) ->
        @raw Array(80).join("*")
