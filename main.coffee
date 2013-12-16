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
    'warn ': colors.yellow
    'info ': colors.blue

class Logger

    constructor: (@options) ->
        @options ?= {}
        if @options.date and not @options.dateFormat?
            @options.dateFormat = 'YYYY-MM-DD hh:mm:ss:S'

    colorify: (text, color) ->
        "#{color[0]}#{text}#{color[1]}"

    format: (level, text) ->
        text = "#{@options.prefix} | #{text}" if @options.prefix?
        if process.env.NODE_ENV isnt 'production'
            level = @colorify level, levelColors[level]

        text = "#{level} - #{text}" if level
        if @options.date
            date = new Date().format @options.dateFormat
            text = "[#{date}] #{text}"
        text

    info: (text) ->
        console.info @format 'info ', text if process.env.NODE_ENV isnt 'test'

    warn: (text) ->
        console.warn @format 'warn ', text if process.env.NODE_ENV isnt 'test'

    error: (text) ->
        console.error @format 'error', text if process.env.NODE_ENV isnt 'test'

    debug: (text) ->
        console.info @format 'debug', text if process.env.NODE_ENV isnt 'test'

    raw: (text) ->
        console.log text

    lineBreak: (text) ->
        @raw Array(80).join("*")
