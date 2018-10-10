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
  abstract class Element
    def to_s(io : IO)
      to_xml(io)
    end

    # Writes the generated XML to the provided *io*.
    def to_xml(io : IO)
      XML.build(io, version: "1.0", indent: "  ") do |xml|
        to_xml(xml)
      end
    end

    # Writes the generated XML to the provided *xml* builder.
    abstract def to_xml(xml : XML::Builder)

    private macro emit(elem)
      xml.element("{{elem}}") { xml.text @{{elem}}.to_s }
    end

    private macro emit(elem, name)
      xml.element({{name}}) { xml.text @{{elem}}.to_s }
    end
  end
end