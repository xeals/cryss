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

require "spec"
require "../src/cryss"

HEADER = "<?xml version=\"1.0\"?>\n"

CLOUD_TEST = "<cloud domain=\"rpc.sys.com\" port=\"80\" path=\"/RPC2\" registerProcedure=\"pingMe\" protocol=\"soap\"/>"

ENCLOSURE_TEST = "<enclosure url=\"http://live.curry.com/mp3/celebritySCms.mp3\" length=\"1069871\" type=\"audio/mpeg\"/>"

ITEM_TEST = HEADER + <<-XML
<item>
  <title>Venice Film Festival Tries to Quit Sinking</title>
  <link>http://www.nytimes.com/2002/09/07/movies/07FEST.html</link>
  <description>Some of the most heated chatter at the Venice Film Festival this week was about the way that the arrival of the stars at the Palazzo del Cinema was being staged.</description>
  <author>oprah@oxygen.net</author>
  <category>Simpsons Characters</category>
  <comments>http://www.myblog.org/cgi-local/mt/mt-comments.cgi?entry_id=290</comments>
  #{ENCLOSURE_TEST}
  <guid isPermaLink="true">http://inessential.com/2002/09/01.php#a2</guid>
  <pubDate>Sun, 19 May 2002 15:21:36 +0000</pubDate>
  <source url="http://www.quotationspage.com/data/qotd.rss">Quotes of the Day</source>
</item>
XML

CHANNEL_TEST = HEADER + <<-XML
<rss version="2.0">
  <channel>
    <title>GoUpstate.com News Headlines</title>
    <link>http://www.goupstate.com/</link>
    <description>The latest news from GoUpstate.com, a Spartanburg Herald-Journal Web site.</description>
    <category>Newspapers</category>
    #{CLOUD_TEST}
    <copyright>Copyright 2002, Spartanburg Herald-Journal</copyright>
    <docs>http://backend.userland.com/rss</docs>
    <generator>MightyInHouse Content System v2.3</generator>
    <language>en-us</language>
    <lastBuildDate>Sat, 7 Sep 2002 09:42:31 +0000</lastBuildDate>
    <managingEditor>geo@herald.com (George Matesky)</managingEditor>
    <pubDate>Sat, 7 Sep 2002 00:00:01 +0000</pubDate>
    <ttl>60</ttl>
    <webMaster>betty@herald.com (Betty Guernsey)</webMaster>
  </channel>
</rss>
XML

SKIP_DAY_TEST = HEADER + <<-XML
<rss version="2.0">
  <channel>
    <title>GoUpstate.com News Headlines</title>
    <link>http://www.goupstate.com/</link>
    <description>The latest news from GoUpstate.com, a Spartanburg Herald-Journal Web site.</description>
    <skipHours>
      <hour>2</hour>
      <hour>6</hour>
      <hour>18</hour>
      <hour>22</hour>
    </skipHours>
    <skipDays>
      <day>Monday</day>
      <day>Wednesday</day>
    </skipDays>
  </channel>
</rss>
XML
