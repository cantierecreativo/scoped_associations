require 'active_support/concern'

module ScopedAssociations
  module ActiveRecord3
    module HasOne
      extend ActiveSupport::Concern

      included do |klass|
        klass.valid_options += [:scoped]
      end

      def build
        reflection = super
        extend_reflection(reflection)
        reflection
      end

      private

      def extend_reflection(reflection)
        if scoped?
          reflection.extend ReflectionExtension
        end
      end

      def scoped?
        options[:scoped]
      end

      module ReflectionExtension
        def foreign_scope
          if options[:as]
            "#{options[:as]}_scope"
          else
            name = active_record.name
            name.underscore.demodulize + "_scope"
          end
        end

        def association_class
          ScopedHasOneAssociation
        end
      end

      class ScopedHasOneAssociation < ActiveRecord::Associations::HasOneAssociation
        def creation_attributes
          attributes = super
          attributes[reflection.foreign_scope] = reflection.name.to_s
          attributes
        end

        def association_scope
          super.where(reflection.foreign_scope => reflection.name.to_s)
        end
      end

    end
  end
end

ActiveRecord::Associations::Builder::HasOne.send :include, ScopedAssociations::ActiveRecord3::HasOne



