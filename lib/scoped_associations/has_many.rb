module ScopedAssociations
  module HasMany

    def valid_options
      super + [:scoped]
    end

    def build
      add_scope
      reflection = super
      extend_reflection(reflection)
      reflection
    end

    private

    def add_scope
      if scoped?
        scope_name = name
        scope_attribute = scoped_attribute
        prev_scope = -> { where(scope_attribute => scope_name) }
        @scope = proc { instance_exec(&prev_scope) }
      end
    end

    def extend_reflection(reflection)
      if scoped?
        reflection.extend ReflectionExtension
      end
    end

    def scoped?
      options[:scoped] && options[:as]
    end

    def scoped_attribute
      options[:as].to_s + "_scope"
    end

    module ReflectionExtension
      def scoped_attribute
        options[:as].to_s + "_scope"
      end

      def association_class
        ScopedHasManyAssociation
      end
    end

    class ScopedHasManyAssociation < ActiveRecord::Associations::HasManyAssociation
      def creation_attributes
        attributes = super
        attributes[reflection.scoped_attribute] = reflection.name.to_s
        attributes
      end
    end
  end
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Associations::Builder::HasMany.send :include, ScopedAssociations::HasMany
end


