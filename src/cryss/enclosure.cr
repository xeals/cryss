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

module RSS
  # Describes a media object that is attached to an item.
  class Enclosure < Element
    # Where the enclosure is located.
    getter url : URI

    # Size in bytes.
    getter length : Int32

    # MIME type of the media.
    getter type : String

    setter url,
           length,
           type

    def initialize(url : URI | String, @length : Int32, @type : String)
      @url = url.is_a?(URI) ? url : URI.parse url
    end

    def to_xml(xml : XML::Builder)
      xml.element("enclosure", url: @url, length: @length, type: @type)
    end
  end
end
