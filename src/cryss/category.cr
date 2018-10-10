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

require "./element"

module RSS
  class Category < Element
    # Includes the item in one or more categories.
    #
    # The value of the element is a forward-slash-separated string that identifies a hierarchic
    # location in the indicated taxonomy. Processors may establish conventions for the
    # interpretation of categories. Two examples are provided below:
    getter name : String

    # Optional attribute that identifies a categorization taxonomy.
    getter domain : URI?

    def initialize(@name : String, domain : URI | String | Nil = nil)
      @domain = domain.is_a?(String) ? URI.parse domain : domain
    end

    def to_xml(xml : XML::Builder)
      if @domain
        xml.element("category", domain: @domain) { xml.text name }
      else
        xml.element("category") { xml.text name }
      end
    end
  end
end
