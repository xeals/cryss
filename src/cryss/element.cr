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
    @custom = {} of String => Hash(String, String)

    def to_s(io : IO)
      to_xml(io)
    end

    # Writes the generated XML to the provided *io*.
    def to_xml(io : IO)
      XML.build(io, version: "1.0", indent: "  ") do |xml|
        to_xml(xml)
      end
    end

    # Adds a non-standard namespaced element to the component.
    #
    # Yields access to a set of namespaced elements and their values.
    #
    # Examples taken from [here](http://static.userland.com/gems/backend/rssMarkPilgrimExample.xml).
    #
    # ```crystal
    # channel = RSS::Channel.new(/* ... */)
    # channel.add_ns(dc: "http://purl.org/dc/elements/1.1")
    # channel.ns("dc") do |dc|
    #   dc["rights"] = "Copyright 2002"
    # end
    #
    # item = RSS::Item.new(title: "New item")
    # item.ns("dc") do |dc|
    #   dc["subject"] = "CSS"
    # end
    #
    # channel << item
    # ```
    #
    # If the namespace already exists, it will yield access to the already existing namespace rather
    # than overwriting it. Duplicate keys inside that namespace will overwrite, however.
    #
    # Note that no sanity checking is (currently) done before serializing an element with a custom
    # namespaced element, as only the top-level element (a `Channel`) has access to specifying the
    # namespace imports.
    def ns(name : String, &block)
      @custom[name] = {} of String => String if @custom[name]?.nil?
      yield @custom[name]
    end

    # Writes the generated XML to the provided *xml* builder.
    abstract def to_xml(xml : XML::Builder)

    private macro emit(elem)
      xml.element("{{elem}}") { xml.text @{{elem}}.to_s }
    end

    private macro emit(elem, name)
      xml.element({{name}}) { xml.text @{{elem}}.to_s }
    end

    private def emit_custom(xml)
      @custom.each do |ns, content|
        content.each do |key, val|
          xml.element("#{ns}:#{key}") { xml.text val }
        end
      end
    end
  end
end
