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
require "uri"

require "./element"

module RSS
  class Image < Element
    # URL of a GIF, JPEG or PNG image that represents the channel.
    getter image : URI

    # Describes the image.
    #
    # Used in the ALT attribute of the HTML <img> tag when the channel is rendered in HTML.
    getter title : String

    # URL of the site, when the channel is rendered, the image is a link to the site. (Note, in
    # practice the image <title> and <link> should have the same value as the channel's <title> and
    # <link>.
    getter link : URI

    # Width of the image in pixels. Default is 88. Maximum of 144.
    getter width : Float32 = 88

    # Height of the image in pixels. Default is 31. Maximum of 400.
    getter height : Float32 = 31

    # Description contains text that is included in the TITLE attribute of the link formed around
    # the image in the HTML rendering.
    getter description : String?

    setter image,
           title,
           link,
           description

    def initialize(image : URI | String, @title : String, link : URI | String)
      @image = image.is_a?(URI) ? image : URI.parse image
      @link = link.is_a?(URI) ? link : URI.parse link
    end

    def width=(width : Float32)
      raise Exception.new "maximum width is 144" if width > 144
      @width = width
    end

    def height=(height : Float32)
      raise Exception.new "maximum height is 400" if height > 400
      @height = height
    end

    # Serialises the image to the XML builder.
    def to_xml(xml : XML::Builder)
      xml.element("image") do
        emit image
        emit title
        emit link
        emit width if @width
        emit height if @height
        emit description if @description
      end
    end
  end
end
