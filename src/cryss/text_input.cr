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

module RSS
  # The purpose of the <textInput> element is something of a mystery. You can use it to specify a
  # search engine box. Or to allow a reader to provide feedback. Most aggregators ignore it.
  class TextInput < Element
    # The label of the Submit button in the text input area.
    getter title : String

    # Explains the text input area.
    getter description : String

    # The name of the text object in the text input area.
    getter name : String

    # The URL of the CGI script that processes text input requests.
    getter link : URI

    setter title,
           description,
           name,
           link

    def initialize(@title : String, @description : String, @name : String, link : URI | String)
      @link = link.is_a?(URI) ? link : URI.parse link
    end

    def to_xml(xml : XML::Builder)
      xml.element("textInput") do
        emit title
        emit description
        emit name
        emit link
      end
    end
  end
end
