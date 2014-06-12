module ScopedAssociations
  module ActiveRecord4
    module HasMany

      def valid_options
        super + [:scoped]
      end

      def build(attributes = {})
        reflection = ActiveRecord::VERSION::MINOR == 0 ? super() : super(attributes)
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
          ScopedHasManyAssociation
        end
      end

      class ScopedHasManyAssociation < ActiveRecord::Associations::HasManyAssociation
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

ActiveRecord::Associations::Builder::HasMany.send :include, ScopedAssociations::ActiveRecord4::HasMany

