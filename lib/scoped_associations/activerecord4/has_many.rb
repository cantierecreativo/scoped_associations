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

      def initialize(model, name, scope, options)
        super
        if scoped?
          search_scope = foreign_scope(model)
          proc_scope = proc { where(search_scope => name) }
          if @scope.nil?
            @scope = proc { instance_eval(&proc_scope) }
          else
            old_scope = @scope
            @scope = proc { instance_eval(&proc_scope)
                              .instance_eval(&old_scope) }
          end
        end
      end

      def foreign_scope(model)
        if options[:as]
          "#{options[:as]}_scope"
        else
          model.name.underscore.demodulize + "_scope"
        end
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
      end
    end
  end
end

ActiveRecord::Associations::Builder::HasMany.send :include, ScopedAssociations::ActiveRecord4::HasMany
