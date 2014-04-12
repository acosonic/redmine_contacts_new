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

require File.expand_path('../../test_helper', __FILE__)

class AddressTest < ActiveSupport::TestCase

  def test_should_generate_full_address
    address = Address.new
    address.street1 = "300 Boylston Ave E"
    address.street2 = "Piso2 Dto.4"
    address.city = "Seattle"
    address.region = "WA"
    address.postcode = "98102"
    address.country_code = "US"
    address.save
    address.reload

    assert_equal "300 Boylston Ave E, Piso2 Dto.4, Seattle, 98102, WA, United States", address.full_address
  end

  def test_should_generate_to_s
    address = Address.new
    address.street1 = "300 Boylston Ave E"
    address.street2 = "Piso2 Dto.4"
    address.city = "Seattle"
    address.region = "WA"
    address.postcode = "98102"
    address.country_code = "US"

    assert_equal "300 Boylston Ave E, Piso2 Dto.4, Seattle, 98102, WA, United States", address.to_s
  end

  def test_should_generate_particular_full_address
    address = Address.new
    address.street1 = "300 Boylston Ave E"
    address.city = "Seattle"
    address.postcode = "98102"
    address.region = ""
    address.country_code = "US"
    address.save
    address.reload

    assert_equal "300 Boylston Ave E, Seattle, 98102, United States", address.full_address
  end

end
