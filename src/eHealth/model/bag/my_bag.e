note
	description: "Summary description for {MY_BAG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_BAG [G -> {HASHABLE, COMPARABLE}]
inherit
	ADT_BAG [G]
create
	make_empty,
	make_from_tupled_array

convert
    make_from_tupled_array ({attached ARRAY [attached TUPLE [G, INTEGER_32]]})

feature -- initialization
	make_empty
		do
			create bag.make_equal(0)
		end

	make_from_tupled_array (a_array: ARRAY [TUPLE [x: G; y: INTEGER]])
		require else
			is_nonnegative(a_array)
		do
			create bag.make_equal(0)
			across
				a_array as cursor
			loop
				Current.extend (cursor.item.x, cursor.item.y)
			end
		end
feature -- bag itself
	bag : HASH_TABLE[INTEGER, G]

feature -- creation queries
	is_nonnegative(a_array: ARRAY [TUPLE [x: G; y: INTEGER]]): BOOLEAN
			-- Are all the `y' fields of tuples in `a_array' non-negative
		do
			Result := across a_array as cursor all
				cursor.item.y >= 0
			end
		ensure then
			correct_result: Result = (across a_array as it all it.item.y >=0 end)
		end

feature -- bag equality
	bag_equal alias "|=|"(other: like Current): BOOLEAN
			-- equal to current object?
		do
			Result := true
			if bag.count /= other.count then
				Result := false
			else
				across
					other as cursor
				loop
					if bag.has (cursor.item) then
						if occurrences (cursor.item) /= other.occurrences(cursor.item) then
							Result := false
						end
					else
						Result := false
					end
				end
			end
		ensure then
			symmetry: Result = (other |=| Current)
		end

feature -- queries
	count: INTEGER
			-- cardinality of the domain
		do
			Result := bag.count
		end


	domain: ARRAY[G]
			-- sorted domain of bag
   		local
   			sorting_list: SORTED_TWO_WAY_LIST [G]
   			i : INTEGER
   		do
   			if count < 1 then
   				create Result.make_empty
   			else
   				create sorting_list.make
	   			across Current as cursor loop
   					sorting_list.sequence_put(cursor.item)
	   			end
	   			sorting_list.compare_objects
	   			sorting_list.sort
	   			i := 1
	   			create Result.make_filled (sorting_list.at (i), 1, count)
	   			across sorting_list as cursor loop
	   				Result.put (cursor.item, i)
	   				i := i + 1
	   			end
   			end
	   		Result.compare_objects
   		ensure then
   			Result.capacity = count
   			value_semantics: Result.object_comparison
   			correct_items: across 1 |..| Result.count as j all
   				has(Result[j.item]) end
   			sorted: across 1 |..| (Result.count-1) as j all
   				Result[j.item] <= Result[j.item+1] end
   		end

 	occurrences alias "[]" (key: G): INTEGER
			-- Anything out of the domain can simply be considered out of the bag,
			-- i.e. has a number of occurrences of 0.
		do
			if bag.has (key) then
				Result := bag.item (key)
			else
				Result := 0
			end
		ensure then
			Result >= 0
			has(key) implies Result > 0
		end

	is_subset_of alias "|<:" (other: like Current): BOOLEAN
			-- current bag is subset of `other'
			-- <=
		do
			Result := across Current as cursor all
				other.has (cursor.item) and other.occurrences(cursor.item) >= occurrences(cursor.item)
			end
		ensure then
			correct_subset:
				Result implies
				across domain as g all
					has(g.item) implies other.has(g.item) and then
					occurrences(g.item) <= other.occurrences(g.item)
				end
		end

feature -- commands
	extend  (a_key: G; a_quantity: INTEGER)
			-- add [a_key, a_quantity] to the bag
			-- add additional quantities if item already is in the bag
		do
			if bag.has (a_key) then
				bag.item (a_key) := bag.item (a_key) + a_quantity
			else
				bag.extend (a_quantity, a_key)
			end
		ensure then
			extended: has(a_key) = (old has(a_key) or a_quantity > 0)
			updated_occurrences:
				occurrences (a_key) = old (occurrences (a_key)) + a_quantity
		end

	add_all (other: like Current)
			-- add all elements in the bag `other'
		do
			across other as cursor loop
				Current.extend (cursor.item, other.occurrences (cursor.item))
			end
		end

	remove  (a_key: G; a_quantity: INTEGER)
			-- remove [a_key, a_quantity] from the bag
		require else
			non_negative: a_quantity >= 0
		do
			if bag.has (a_key) then
				if bag.item (a_key) > a_quantity then
					bag.item (a_key) := bag.item (a_key) - a_quantity
				else
					bag.remove (a_key)
				end
			end
		ensure then
			extended:
				has(a_key) = (a_quantity < old occurrences (a_key))
			updated_occurrences:
				occurrences (a_key) = old (occurrences (a_key)) - a_quantity or old (occurrences (a_key)) - a_quantity < 0
			subtract: old occurrences (a_key) > a_quantity
				implies has(a_key)
			       and then occurrences (a_key) = old occurrences (a_key) - a_quantity
			zero: old occurrences (a_key) <= a_quantity
				implies not has(a_key) and then occurrences (a_key)=0
		end

	remove_all (other: like Current)
		  -- bag difference
		  -- i.e. no. of items in Current
		  -- minus no. of times in other,
		  -- or zero
		require else
			other /= Current
		do
			across other as cursor loop
				Current.remove (cursor.item, other.occurrences (cursor.item))
			end
		ensure then
			other = old other
		end

feature -- Access
	new_cursor: MY_BAG_ITERATION_CURSOR [G]
			-- Fresh cursor associated with current structure
		local
			cursor : MY_BAG_ITERATION_CURSOR[G]
		do
			create cursor.make(bag)
			Result := cursor
		ensure then
			result_attached: Result /= Void
		end

end
