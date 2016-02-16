#!/usr/bin/env ruby
require "nokogiri"

module Color
  extend self

  BG = "#ebedf3"
  FG = "#3f4e5c"
  WHITE = "#f8f8f8"
  GRAY = "#666666"
  BLACK = "#222222"
  RED = "#cc0000"
  GREEN = "#00aa00"
  BLUE = "#0000cc"
  YELLOW = "#bb9900"
  ORANGE = "#dd6600"
  PURPLE = "#aa00ee"
  CYAN = "#0088aa"
  NO_ = "#ff00ff"

  def dilute(color, amount="0a")
    "#{color}#{amount}"
  end

  def plistify(xml, data)
    case [data.class]
    when [Hash]
      plistify_dict(xml, data)
    when [Array]
      plistify_array(xml, data)
    when [Fixnum], [String], [Symbol]
      plistify_string(xml, data)
    else
      fail
    end
  end

  def plistify_array(xml, list)
    xml.array {
      list.each {|x|
        plistify(xml, x)
      }
    }
  end

  def plistify_dict(xml, hash)
    xml.dict {
      hash.each {|k, v|
        xml.key(k)
        plistify(xml, v)
      }
    }
  end

  def plistify_string(xml, str)
    xml.string(str.to_s)
  end

  def config
    {
      author: "Brian Mock <brian@mockbrian.com>",
      name: "Blue Blur",
      colorSpaceName: "sRGB",
      uuid: "263f4a1c-f382-11e4-8f8f-20c9d048f613",
      settings: [{ settings: settings }, *scopes],
    }
  end

  def settings
    {
      background: BG,
      divider: BLACK,
      foreground: FG,
      invisibles: RED,
      lineHighlight: dilute(BLACK, "08"),
      selection: dilute(BLACK, "33"),
      selectionForeground: BLACK,
      shadow: dilute(BLACK, "40"),
      shadowWidth: 8,
      gutter: dilute(WHITE, "80"),
      gutterForeground: dilute(BLACK, "50"),
      guide: dilute(BLACK, "18"),
      activeGuide: dilute(BLACK, "30"),
    }
  end

  def scopes
    scopes = [
      ["Parameter", "variable.parameter.function"],
      ["Comments", "comment, punctuation.definition.comment"],
      ["Punctuation",
      "punctuation.definition.string, punctuation.definition.variable, punctuation.definition.string, punctuation.definition.parameters, punctuation.definition.string, punctuation.definition.array, punctuation.terminator"],
      ["Delimiters", "punctuation.separator, punctuation.section, meta.brace, meta.delimiter"],
      ["Operators", "keyword.operator"],
      ["Keywords", "keyword"],
      ["Variables", "variable"],
      ["Search", "entity.name.filename.find-in-files"],
      ["Functions",
      "entity.name.function, meta.require, support.function.any-method"],
      ["Classes", "support.class, entity.name.class, entity.name.type.class, meta.class"],
      ["Methods", "keyword.other.special-method"],
      ["Storage", "storage"],
      ["Support", "support.function"],
      ["Strings", "string, entity.other.inherited-class, punctuation.definition.string"],
      ["Integers", "constant.numeric"],
      ["Symbols", "constant.other.symbol"],
      ["Floats", "none"],
      ["Boolean", "constant.language.boolean"],
      ["Constants", "constant"],
      ["Tags", "entity.name.tag, punctuation.definition.tag"],
      ["Attributes", "entity.other.attribute-name"],
      ["Attribute IDs",
      "entity.other.attribute-name.id, punctuation.definition.entity"],
      ["Selector", "meta.selector"],
      ["Headings",
      "markup.heading punctuation.definition.heading, entity.name.section"],
      ["Units", "keyword.other.unit"],
      ["Bold", "markup.bold, punctuation.definition.bold"],
      ["Italic", "markup.italic, punctuation.definition.italic"],
      ["Code", "markup.raw.inline"],
      ["Link Text", "string.other.link"],
      ["Link Url", "meta.link"],
      ["Lists", "markup.list"],
      ["Quotes", "markup.quote"],
      ["Separator", "meta.separator"],
      ["Inserted", "markup.inserted"],
      ["Deleted", "markup.deleted"],
      ["Changed", "markup.changed"],
      ["Colors", "constant.other.color"],
      ["Regular Expressions", "string.regexp"],
      ["Escape Characters", "constant.character.escape"],
      ["Embedded", "punctuation.section.embedded, variable.interpolation"],
      ["Illegal", "invalid, invalid.illegal"],
      ["Broken", "invalid.broken"],
      ["Deprecated", "invalid.deprecated"],
      ["Unimplemented", "invalid.unimplemented"],
    ]
    scopes.map {|name, scope|
      settings = named_scope_to_settings(name)
      if settings
        {
          name: name,
          scope: scope,
          settings: named_scope_to_settings(name)
        }
      else
        nil
      end
    }.compact
  end

  def style(color, *font_style)
    {
      foreground: color,
      background: dilute(color),
      fontStyle: font_style.map(&:to_s).join(" "),
    }
  end

 @_settings = {
    "Parameter" => style(PURPLE),
    "Comments" => style(GREEN),
    "Punctuation" => style(YELLOW),
    "Delimiters" => style(YELLOW),
    "Operators" => style(YELLOW),
    "Search" => style(PURPLE, :bold),
    "Keywords" => style(BLUE, :bold),
    "Variables" => style(CYAN),
    "Functions" => style(CYAN),
    "Classes" => style(PURPLE,),
    "Methods" => style(PURPLE, :bold),
    "Storage" => style(BLUE, :bold),
    "Support" => style(PURPLE, :bold),
    "Strings" => style(RED),
    "Symbols" => style(ORANGE),
    "Integers" => style(ORANGE),
    "Floats" => style(ORANGE),
    "Boolean" => style(ORANGE),
    "Constants" => style(PURPLE),
    "Tags" => style(BLUE),
    "Attributes" => style(CYAN),
    "Attribute IDs" => style(CYAN),
    "Selector" => style(NO_),
    "Headings" => style(BLUE, :bold),
    "Units" => style(NO_),
    "Bold" => style(PURPLE, :bold),
    "Italic" => style(PURPLE, :italic),
    "Code" => style(RED),
    "Link Text" => style(BLACK, :bold),
    "Link Url" => style(BLUE),
    "Lists" => style(ORANGE),
    "Quotes" => style(YELLOW),
    "Separator" => style(YELLOW),
    "Inserted" => style(GREEN),
    "Deleted" => style(RED),
    "Changed" => style(YELLOW),
    "Colors" => style(NO_),
    "Regular Expressions" => style(ORANGE),
    "Escape Characters" => style(GREEN),
    "Embedded" => style(PURPLE),
    "Broken" => style("RED", :bold),
    "Deprecated" => style("RED", :bold),
    "Unimplemented" => style("RED", :bold),
    "Illegal" => {
      foreground: WHITE,
      background: dilute(RED, "cc"),
      fontStyle: "bold",
    },
  }

  def named_scope_to_settings(name)
    @_settings[name]
  end
end

THEME_PATH = File.join(
  Dir.home,
  "Library",
  "Application Support",
  "Sublime Text 3",
  "Packages",
  "User",
  "Blue Blur.tmTheme"
)

doc = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
  xml.doc.create_internal_subset(
    "plist",
    "-//Apple//DTD PLIST 1.0//EN",
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd"
  )
  xml.plist { Color.plistify(xml, Color.config) }
end
xml = doc.to_xml
puts xml
File.write(THEME_PATH, xml)
