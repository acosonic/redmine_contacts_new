require_dependency 'custom_fields_helper'

module RedmineContacts
  module Patches    

    module CustomFieldsHelperPatch
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          if Redmine::VERSION::MAJOR >= 2 && Redmine::VERSION::MINOR >= 5
            alias_method_chain :render_custom_fields_tabs, :render_custom_tab
            alias_method_chain :custom_field_type_options, :custom_tab_options
          else
            alias_method_chain :custom_fields_tabs, :custom_tab
          end
        end
      end

	  module ClassMethods                          
      end

      module InstanceMethods
#        def custom_fields_tabs_with_contacts_tab
#          new_tabs = []
#          new_tabs << {:name => 'ContactCustomField', :partial => 'custom_fields/index', :label => :label_contact_plural}
#          new_tabs << {:name => 'DealCustomField', :partial => 'custom_fields/index', :label => :label_deal_plural}
#          new_tabs << {:name => 'NoteCustomField', :partial => 'custom_fields/index', :label => :label_crm_note_plural}
#          return custom_fields_tabs_without_contacts_tab | new_tabs
#        end

        def custom_fields_tabs_with_custom_tab          
          add_cf
          custom_fields_tabs_without_custom_tab        
        end
        
        def render_custom_fields_tabs_with_render_custom_tab(types)          
          add_cf
          render_custom_fields_tabs_without_render_custom_tab(types)
        end

        def custom_field_type_options_with_custom_tab_options          
          add_cf
          custom_field_type_options_without_custom_tab_options
        end 

      private
       
        def add_cf
         cf = {:name => 'ContactCustomField', :partial => 'custom_fields/index', :label => :label_contact_plural}
         cf1 = {:name => 'DealCustomField', :partial => 'custom_fields/index', :label => :label_deal_plural}
         cf2 = {:name => 'NoteCustomField', :partial => 'custom_fields/index', :label => :label_crm_note_plural}
         unless CustomFieldsHelper::CUSTOM_FIELDS_TABS.index { |f| f[:name] == cf[:name] }
            CustomFieldsHelper::CUSTOM_FIELDS_TABS << cf << cf1 << cf2
          end 
        end

      end
      
    end
    
  end
end

unless CustomFieldsHelper.included_modules.include?(RedmineContacts::Patches::CustomFieldsHelperPatch)
  CustomFieldsHelper.send(:include, RedmineContacts::Patches::CustomFieldsHelperPatch)
end
