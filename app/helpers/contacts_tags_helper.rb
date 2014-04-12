# encoding: utf-8
#
# This file is a part of Redmine CRM (redmine_contacts) plugin,
# customer relationship management plugin for Redmine
#
# Copyright (C) 2011-2013 Kirill Bezrukov
# http://www.redminecrm.com/
#
# redmine_contacts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_contacts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_contacts.  If not, see <http://www.gnu.org/licenses/>.

module ContactsTagsHelper

  def color_picker(name, color="#aaa")
    #build the hexes
    hexes = []
    (0..15).step(3) do |one|
      (0..15).step(3) do |two|
        (0..15).step(3) do |three|
          hexes << "#" + one.to_s(16) + two.to_s(16) + three.to_s(16)
        end
      end
    end
    arr = []
    on_change_function = "onChange=\"this.style.backgroundColor=this.options[this.selectedIndex].style.backgroundColor;\""
    10.times { arr << "&nbsp;" }
    returning html = '' do
      html << "<select name=#{name}[color] id=#{name}_color #{on_change_function} style=\"background-color:#{color};\">"
      html << hexes.collect {|c| "<option value='#{c.from(1).to_i(16)}'
                                          style='background-color: #{c}
                                          #{'selected="select"' if c == color }'>
                                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                          #{c}
                                          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                  </option>" }.join("\n")
        html << "</select>"
      end
    end

  end
