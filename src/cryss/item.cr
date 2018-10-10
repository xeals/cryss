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

require "./category"
require "./element"
require "./enclosure"

module RSS
  # A channel may contain any number of `Item`s. An item may represent a "story" -- much like a
  # story in a newspaper or magazine; if so its description is a synopsis of the story, and the link
  # points to the full story. An item may also be complete in itself, if so, the description
  # contains the text (entity-encoded HTML is allowed), and the link and title may be omitted. All
  # elements of an item are optional, however at least one of title or description must be present.
  class Item < Element
    # The title of the item.
    getter title : String?

    # The URL of the item.
    getter link : URI?

    # The item synopsis.
    getter description : String?

    # Email address of the author of the item.
    getter author : String?

    # Includes the item in one or more categories.
    #
    # The value of the element is a forward-slash-separated string that identifies a hierarchic
    # location in the indicated taxonomy. Processors may establish conventions for the
    # interpretation of categories. Two examples are provided below:
    # getter category : String?
    getter category : Category?

    # Optional <category> attribute that identifies a categorization taxonomy.
    # getter category_domain : URI?

    # Optional URL of the comments page for the item.
    #
    # ```
    # <comments>http://rateyourmusic.com/yaccs/commentsn/blogId=705245&itemId=271</comments>
    # ```
    getter comments : URI?

    # Describes a media object that is attached to the item.
    getter enclosure : Enclosure?

    # Optional globally unique identifier.
    #
    # It's a string that uniquely identifies the item. When present, an aggregator may choose to use
    # this string to determine if an item is new.
    #
    # ```
    # <guid>http://some.server.com/weblogItem3207<guid>
    # ```
    #
    # There are no rules for the syntax of a guid. Aggregators must view them as a string. It's up
    # to the source of the feed to establish the uniqueness of the string.
    #
    # If the guid element has an attribute named "isPermaLink" with a value of true, the reader may
    # assume that it is a permalink to the item, that is, a url that can be opened in a Web browser,
    # that points to the full item described by the <item> element. An example:
    #
    # ```
    # <guid isPermaLink="true">http://inessential.com/2002/09/01.php#a2</guid>
    # ```
    #
    # *is_perma_link* is optional and defaults to true. If its value is false, the guid may not be
    # assumed to be a url, or a url to anything in particular.
    getter guid : URI?

    # See `#guid`.
    getter guid_is_perma_link : Bool = true

    # <pubDate> is an optional sub-element of <item>.
    #
    # Its value is a date, indicating when the item was published. If it's a date in the future,
    # aggregators may choose to not display the item until that date.
    getter pub_date : Time?

    # The RSS channel that the item came from.
    getter source : String?

    # Required if *source* is non-nil.
    getter source_url : URI?

    setter title,
           link,
           description,
           author,
           category,
           comments,
           enclosure,
           guid,
           guid_is_perma_link,
           pub_date,
           source,
           source_url

    def initialize(@title = nil, @description = nil)
      raise Exception.new "either title or description are required for RSS item" if !(@title || @description)
    end

    # Serialises the item to the XML builder.
    def to_xml(xml : XML::Builder)
      raise Exception.new "source_url is required if source is non-nil for item" if @source && !@source_url

      xml.element("item") do
        emit title if @title
        emit link if @link
        emit description if @description
        emit author if @author
        if category = @category
          category.to_xml xml
        end
        emit comments if @comments
        if enc = @enclosure
          enc.to_xml xml
        end
        xml.element("guid", isPermaLink: @guid_is_perma_link) { xml.text @guid.to_s } if @guid
        if pub = @pub_date
          xml.element("pubDate") { xml.text pub.to_rfc2822 }
        end
        xml.element("source", url: @source_url.to_s) { xml.text @source.to_s } if @source

        emit_custom xml
      end
    end
  end
end
