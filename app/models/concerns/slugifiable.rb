module Slugifiable
    module InstanceMethods
        def slug
            the_name = self.name
            slug = the_name.downcase.gsub(' ', '-').gsub(/[^\w-]/, '')
        end
    end

    module ClassMethods
        def find_by_slug(slug)
            @slug = slug
            findable_slug
            @found = self.where("name LIKE ?", @findable)[0]
        end

        def findable_slug
            split_slug = @slug.split('-')
            @findable = "#{split_slug.first}" + "%" + "#{split_slug.last}"
        end
    end
end