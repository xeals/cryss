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
  # Optional sub-element of a channel.
  #
  # It specifies a web service that supports the rssCloud interface which can be implemented in
  # HTTP-POST, XML-RPC or SOAP 1.1.
  #
  # Its purpose is to allow processes to register with a cloud to be notified of updates to the
  # channel, implementing a lightweight publish-subscribe protocol for RSS feeds.
  #
  # ```
  # <cloud domain="radio.xmlstoragesystem.com" port="80" path="/RPC2" registerProcedure="xmlStorageSystem.rssPleaseNotify" protocol="xml-rpc" />
  # ```
  #
  # In this example, to request notification on the channel it appears in, you would send an XML-RPC
  # message to radio.xmlstoragesystem.com on port 80, with a path of /RPC2. The procedure to call is
  # xmlStorageSystem.rssPleaseNotify.
  #
  # A full explanation of this element and the rssCloud interface is
  # [here](http://www.thetwowayweb.com/soapmeetsrss#rsscloudInterface).
  class Cloud < Element
    getter domain : URI

    getter port : Int32

    getter path : String

    getter register_procedure : String

    getter protocol : String

    setter domain,
           port,
           path,
           register_procedure,
           protocol

    def initialize(domain : URI | String,
                   @port : Int32,
                   @path : String,
                   @register_procedure : String,
                   @protocol : String)
      @domain = domain.is_a?(String) ? URI.parse domain : domain
    end

    def to_xml(xml : XML::Builder)
      xml.element(
        "cloud",
        domain: @domain.to_s,
        port: @port.to_s,
        path: @path,
        registerProcedure: @register_procedure,
        protocol: @protocol
      )
    end
  end
end
