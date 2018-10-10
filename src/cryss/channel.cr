# Copyright 2018 Alex Smith
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "xml"

require "./cloud"
require "./day"
require "./element"
require "./image"
require "./item"
require "./text_input"

module RSS
  # Contains information about an RSS channel (metadata) and its contents.
  #
  # For precise documentation, see <https://validator.w3.org/feed/docs/rss2.html>
  class Channel < Element
    # The name of the channel.
    #
    # It's how people refer to your service. If you have an HTML website that contains the same
    # information as your RSS file, the title of your channel should be the same as the title of
    # your website.
    getter title : String

    # The URL to the HTML website corresponding to the channel.
    getter link : URI

    # Phrase or sentence describing the channel.
    getter description : String

    # The language the channel is written in.
    #
    # This allows aggregators to group all Italian language sites, for example, on a single page. A
    # list of allowable values for this element, as provided by Netscape, is
    # [here](http://backend.userland.com/stories/storyReader$16). You may also use [values
    # defined](http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes) by the W3C.
    #
    # Example: en-us
    getter language : String?

    # Copyright notice for content in the channel.
    #
    # Example: Copyright 2002, Spartanburg Herald-Journal
    getter copyright : String?

    # Email address for person responsible for editorial content.
    #
    # Example: geo@herald.com (George Matesky)
    getter managing_editor : String?

    # Email address for person responsible for technical issues relating to channel.
    #
    # Example: betty@herald.com (Betty Guernsey)
    getter webmaster : String?

    # The publication date for the content in the channel.
    #
    # For example, the New York Times publishes on a daily basis, the publication date flips once
    # every 24 hours. That's when the pubDate of the channel changes. All date-times in RSS conform
    # to the Date and Time Specification of [RFC 822](http://asg.web.cmu.edu/rfc/rfc822.html), with
    # the exception that the year may be expressed with two characters or four characters (four
    # preferred).
    #
    # Example: Sat, 07 Sep 2002 0:00:01 GMT
    getter pub_date : Time?

    # The last time the content of the channel changed.
    #
    # Example: Sat, 07 Sep 2002 9:42:31 GMT
    getter last_build_date : Time?

    # Specify one or more categories that the channel belongs to. Follows the same rules as the
    # `Item`-level category element. More info.
    getter category : Array(Category) = [] of Category

    # A string indicating the program used to generate the channel.
    getter generator : String = "cryss"

    # A URL that points to the documentation for the format used in the RSS file.
    #
    # Defaults to the W3 RSS 2.0 specification. It's for people who might stumble across an RSS file
    # on a Web server 25 years from now and wonder what it is.
    getter docs : URI = URI.parse "https://validator.w3.org/feed/docs/rss2.html"

    # Allows processes to register with a `Cloud` to be notified of updates to the channel,
    # implementing a lightweight publish-subscribe protocol for RSS feeds. More info here.
    getter cloud : Cloud?

    # Time to live.
    #
    # It's a number of minutes that indicates how long a channel can be cached before refreshing
    # from the source. More info here.
    getter ttl : Int32?

    # Specifies a GIF, JPEG or PNG image that can be displayed with the channel.
    getter image : Image?

    # Specifies a `TextInput` box that can be displayed with the channel.
    getter text_input : TextInput?

    # A hint for aggregators telling them which hours they can skip.
    getter skip_days : Array(Day) = [] of Day

    # A hint for aggregators telling them which days they can skip.
    getter skip_hours : Array(Int32) = [] of Int32

    setter title,
           link,
           description,
           category,
           cloud,
           copyright,
           docs,
           generator,
           image,
           language,
           last_build_date,
           managing_editor,
           pub_date,
           skip_days,
           skip_hours,
           text_input,
           ttl,
           webmaster

    # Contained elements of the channel.
    getter items : Array(Item) = [] of Item

    @namespaces = {} of String => String

    def initialize(link : URI | String, @title : String, @description : String)
      @link = link.is_a?(URI) ? link : URI.parse link
    end

    def push(item : Item)
      @items << item
    end

    def <<(item : Item)
      push item
    end

    def add_ns(name : String | Symbol,
               url : URI | String)
      @namespaces["xmlns:#{name.to_s}"] = url.to_s
    end

    def add_ns(**ns)
      ns.each do |k, v|
        add_ns(k, v)
      end
    end

    # Serialises the channel to the XML builder.
    def to_xml(xml : XML::Builder)
      xml.element("rss", version: "2.0") do
        xml.attributes(@namespaces)
        xml.element("channel") do
          emit title
          emit link
          emit description
          @category.each do |cat|
            cat.to_xml xml
          end
          if cloud = @cloud
            cloud.to_xml xml
          end
          emit copyright if @copyright
          emit docs if @docs
          emit generator if @generator
          if image = @image
            image.to_xml xml
          end
          emit language if @language
          if lbd = @last_build_date
            xml.element("lastBuildDate") { xml.text lbd.to_rfc2822 }
          end
          emit managing_editor, "managingEditor" if @managing_editor
          if pub = @pub_date
            xml.element("pubDate") { xml.text pub.to_rfc2822 }
          end
          emit text_input, "textInput" if @text_input
          emit ttl if @ttl
          emit webmaster, "webMaster" if @webmaster

          # skips
          if !@skip_hours.empty?
            xml.element("skipHours") do
              @skip_hours.each do |hour|
                xml.element("hour") { xml.text hour.to_s }
              end
            end
          end

          if !@skip_days.empty?
            xml.element("skipDays") do
              @skip_days.each do |day|
                xml.element("day") { xml.text day.to_s }
              end
            end
          end

          emit_custom xml

          @items.each do |item|
            item.to_xml xml
          end
        end
      end
    end
  end
end
