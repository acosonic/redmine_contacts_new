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

require_dependency 'queries_helper'

module RedmineContacts
  module Patches
    module QueriesHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          alias_method_chain :column_content, :contacts
        end
      end


      module InstanceMethods
        # include ContactsHelper

        def column_content_with_contacts(column, issue)
          if column.name.eql? :contacts
      			column.value(issue).collect{ |contact| content_tag(
      				:span,
      				link_to(avatar_to(contact, :size => "16"),
      						contact_path(contact), :id => "avatar") + ' ' +
      						link_to_source(contact),
      				:class => "contact") }.join(', ')
          else
            column_content_without_contacts(column, issue)
          end
        end
      end

    end
  end
end

unless QueriesHelper.included_modules.include?(RedmineContacts::Patches::QueriesHelperPatch)
  QueriesHelper.send(:include, RedmineContacts::Patches::QueriesHelperPatch)
end
