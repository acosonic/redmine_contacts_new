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

class ContactsSetting < ActiveRecord::Base
  unloadable

  belongs_to :project

  cattr_accessor :settings
  acts_as_attachable

  # Hash used to cache setting values
  @contacts_cached_settings = {}
  @contacts_cached_cleared_on = Time.now

  validates_uniqueness_of :name, :scope => [:project_id]

  # Returns the value of the setting named name
  def self.[](name, project_id)
    project_id = project_id.id if project_id.is_a?(Project)
    v = @contacts_cached_settings[hk(name, project_id)]
    v ? v : (@contacts_cached_settings[hk(name, project_id)] = find_or_default(name, project_id).value)
  end

  def self.[]=(name, project_id, v)
    project_id = project_id.id if project_id.is_a?(Project)
    setting = find_or_default(name, project_id)
    setting.value = (v ? v : "")
    @contacts_cached_settings[hk(name, project_id)] = nil
    setting.save
    setting.value
  end

  # Checks if settings have changed since the values were read
  # and clears the cache hash if it's the case
  # Called once per request
  def self.check_cache
    settings_updated_on = ContactsSetting.maximum(:updated_on)
    if settings_updated_on && @contacts_cached_cleared_on <= settings_updated_on
      clear_cache
    end
  end

    # Clears the settings cache
  def self.clear_cache
    @contacts_cached_settings.clear
    @contacts_cached_cleared_on = Time.now
    logger.info "Contacts settings cache cleared." if logger
  end

  def self.vcard?
    Object.const_defined?(:Vcard)
  end

  def self.spreadsheet?
    Object.const_defined?(:Spreadsheet)
  end

  private

  def self.hk(name, project_id)
    "#{name}-#{project_id.to_s}"
  end

  # Returns the Setting instance for the setting named name
  # (record found in database or new record with default value)
  def self.find_or_default(name, project_id)
    name = name.to_s
    setting = find_by_name_and_project_id(name, project_id)
    setting ||= new(:name => name, :value => '', :project_id => project_id)
  end

end
