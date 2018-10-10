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

require "./spec_helper"

describe RSS do
  it "builds enclosure" do
    w3 = HEADER + ENCLOSURE_TEST

    ex_enclosure.to_s.strip.should eq w3
  end

  it "builds cloud" do
    w3 = HEADER + CLOUD_TEST

    ex_cloud.to_s.strip.should eq w3
  end

  it "builds item" do
    item = RSS::Item.new title: "Venice Film Festival Tries to Quit Sinking"

    item.link = URI.parse "http://www.nytimes.com/2002/09/07/movies/07FEST.html"
    item.description = "Some of the most heated chatter at the Venice Film Festival this week was about the way that the arrival of the stars at the Palazzo del Cinema was being staged."
    item.author = "oprah@oxygen.net"
    item.category = RSS::Category.new "Simpsons Characters"
    item.comments = URI.parse "http://www.myblog.org/cgi-local/mt/mt-comments.cgi?entry_id=290"
    item.enclosure = ex_enclosure
    item.guid = URI.parse "http://inessential.com/2002/09/01.php#a2"
    item.pub_date = Time.parse_iso8601 "2002-05-19T15:21:36Z"
    item.source = "Quotes of the Day"
    item.source_url = URI.parse "http://www.quotationspage.com/data/qotd.rss"

    item.to_s.strip.should eq ITEM_TEST
  end

  it "builds channel" do
    chan = base_channel
    chan.language = "en-us"
    chan.copyright = "Copyright 2002, Spartanburg Herald-Journal"
    chan.managing_editor = "geo@herald.com (George Matesky)"
    chan.webmaster = "betty@herald.com (Betty Guernsey)"
    chan.pub_date = Time.parse_iso8601 "2002-09-07T00:00:01Z"
    chan.last_build_date = Time.parse_iso8601 "2002-09-07T09:42:31Z"
    chan.category = [RSS::Category.new "Newspapers"]
    chan.generator = "MightyInHouse Content System v2.3"
    chan.docs = URI.parse "http://backend.userland.com/rss"
    chan.cloud = ex_cloud
    chan.ttl = 60

    chan.to_s.strip.should eq CHANNEL_TEST
  end

  it "skips days and hours" do
    chan = base_channel
    chan.skip_days = [RSS::Day::Monday, RSS::Day::Wednesday]
    chan.skip_hours = [2, 6, 18, 22]

    chan.to_s.strip.should eq SKIP_DAY_TEST
  end

  it "adds namespace" do
    chan = base_channel
    chan.add_ns(dc: "http://purl.org/dc/elements/1.1")
    chan.ns("dc") do |dc|
      dc["rights"] = "Copyright 2002"
    end

    item = RSS::Item.new(title: "New item")
    item.ns("dc") do |dc|
      dc["subject"] = "CSS"
    end
    chan << item

    chan.to_s.strip.should eq NAMESPACE_TEST
  end
end
