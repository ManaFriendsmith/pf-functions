local rm = {}
local misc = require("misc")

local function FindIngredientInList(haystack, needle)
  for k, v in pairs(haystack) do
    if v[1] == needle or v["name"] == needle then
      return k
    end
  end
  return nil
end

local function StandardizeRecipe(recipe)
  if type(recipe) == "string" then
    recipe = misc.GetPrototype(recipe, "recipe")
  end
  if recipe then
    if not recipe.pf_standardized then
      if recipe.result and not recipe.results then
        --recipe result can only be an item, never a fluid
        recipe.results = {{type="item", name=recipe.result, amount=recipe.result_count or 1}}
        recipe.result = nil
        recipe.result_count = nil
      end

      recipe.pf_standardized = true
    end
  end
end

local function GetIngredientCount(recipe, ingredient)
  if type(recipe) == "string" then
    recipe = misc.GetPrototype(recipe, "recipe")
  end
  rm.StandardizeRecipe(recipe)
  if not recipe then
    return 0
  end
  local index = rm.FindIngredientInList(recipe.ingredients, ingredient)
  if index then
    if recipe.ingredients[index][2] then
      return recipe.ingredients[index][2]
    end
    if recipe.ingredients[index].amount then
      return recipe.ingredients[index].amount
    end
  end
  return 0
end

local function AddIngredient(recipe, ingredient, amount, catalyst)
  if type(recipe) == "string" then
    recipe = misc.GetPrototype(recipe, "recipe")
    if not recipe then
      return
    end
  end
  rm.StandardizeRecipe(recipe)

  if type(ingredient) == "string" then
    if data.raw.fluid[ingredient] then
      ingredient = {type="fluid", name=ingredient, amount=amount or 1}
    else
      ingredient = {type="item", name=ingredient, amount=amount or 1}
    end
  end

  local found = false

  for k, v in pairs(recipe.ingredients) do
    if v.type == ingredient.type or (ingredient.type == "item" and not v.type) then
      if v.name == ingredient.name or v[2] == ingredient.name then
        if v.amount then
          v.amount = v.amount + ingredient.amount
        else
          v[2] = v[2] + ingredient.amount
        end
        found = true
        break
      end
    end
  end

  if not found then
    table.insert(recipe.ingredients, ingredient)
  end

  recipe.regenerate_recycle_recipe = true
end

local function RemoveIngredient(recipe, ingredient, amount, catalyst)
  if type(recipe) == "string" then
    recipe = misc.GetPrototype(recipe, "recipe")
    if not recipe then
      return
    end
  end
  StandardizeRecipe(recipe)

  if type(ingredient) == "string" then
    if data.raw.fluid[ingredient] then
      ingredient = {type="fluid", name=ingredient, amount=amount or 1}
    else
      ingredient = {type="item", name=ingredient, amount=amount or 1}
    end
  end

  local found = false

  for k, v in pairs(recipe.ingredients) do
    if v.type == ingredient.type or (ingredient.type == "item" and not v.type) then
      if v.name == ingredient.name or v[2] == ingredient.name then
        if v.amount then
          v.amount = v.amount - ingredient.amount
          if v.amount <= 0 then
            table.remove(recipe.ingredients, k)
          end
        else
          v[2] = v[2] - ingredient.amount
          if v[2] <= 0 then
            table.remove(recipe.ingredients, k)
          end
        end
        found = true
        break
      end
    end
  end
  recipe.regenerate_recycle_recipe = true
end

local function AddProduct(recipe, ingredient, amount)
  if type(recipe) == "string" then
    recipe = misc.GetPrototype(recipe, "recipe")
    if not recipe then
      return
    end
  end

  if type(ingredient) == "string" then
    ingredient = {
      type = data.raw.fluid[ingredient] and "fluid" or "item",
      name = ingredient,
      amount_min = amount or 1,
      amount_max = amount or 1,
      probability = 1
    }
  end

  --if a fully specified ingredient was passed, convert to min and max format.
  --makes things easier later.
  if ingredient.amount then
    ingredient.amount_min = ingredient.amount
    ingredient.amount_max = ingredient.amount
  end
  if not ingredient.probability then
    ingredient.probability = 1
  end

  if not recipe.results then
    recipe.results = {}
  end

  local merged = false

  for k, v in pairs(recipe.results) do
    if v.type == ingredient.type and v.name == ingredient.name and (v.probability or 1) == (ingredient.probability or 1) then
      if v.type == "item" or v.temperature == ingredient.temperature or ingredient.temperature == nil then
        --The products match. Time to merge.
        merged = true

        --merge amounts
        if v.amount then
          if ingredient.amount_min == ingredient.amount_max then
            v.amount = v.amount + ingredient.amount_min
          else
            v.amount_min = v.amount + ingredient.amount_min
            v.amount_max = v.amount + ingredient.amount_max
            v.amount = nil
          end
        else
          v.amount_min = v.amount_min + ingredient.amount_min
          v.amount_max = v.amount_max + ingredient.amount_max
        end

        --merge catalyst data
        if ingredient.ignored_by_stats then
          v.ignored_by_stats = (v.ignored_by_stats or 0) + ingredient.ignored_by_stats
        end
        if ingredient.ignored_by_productivity then
          v.ignored_by_productivity = (v.ignored_by_productivity or 0) + ingredient.ignored_by_productivity
        end
        break
      end
    end
  end
  if not merged then
    if #recipe.results == 1 then
      recipe.main_product = recipe.results[1].name
    end
    table.insert(recipe.results, ingredient)
  end
end

local function RemoveProduct(recipe, ingredient, amount)
  if type(recipe) == "string" then
    recipe = misc.GetPrototype(recipe, "recipe")
    if not recipe then
      return
    end
  end
  rm.StandardizeRecipe(recipe)

  if type(ingredient) == "string" then
    ingredient = {
      type = misc.GetPrototype(ingredient, "fluid") and "fluid" or "item",
      name = ingredient,
      amount_min = amount or 1,
      amount_max = amount or 1,
      probability = 1
    }
  end
  if ingredient.amount then
    ingredient.amount_min = ingredient.amount
    ingredient.amount_max = ingredient.amount
  end
  if not ingredient.probability then
    ingredient.probability = 1
  end

  if not recipe.results then
    recipe.results = {}
  end

  for k, v in pairs(recipe.results) do
    if v.type == ingredient.type and v.name == ingredient.name and (v.probability or 1) == ingredient.probability then
      if v.type == "item" or v.temperature == ingredient.temperature or (ingredient.temperature == nil and v.temperature == misc.GetPrototype(v.name, "fluid").default_temperature) then
        --merge amounts
        if v.amount then
          if ingredient.amount_min == ingredient.amount_max then
            v.amount = v.amount - ingredient.amount_min
          else
            v.amount_min = math.max(v.amount - ingredient.amount_min, 0)
            v.amount_max = v.amount - ingredient.amount_max
            v.amount = nil
          end
        else
          v.amount_min = math.max(v.amount_min - ingredient.amount_min, 0)
          v.amount_max = v.amount_max - ingredient.amount_max
        end

        --merge catalyst data
        if ingredient.ignored_by_stats then
          v.ignored_by_stats = (v.ignored_by_stats or 0) - ingredient.ignored_by_stats
        end
        if ingredient.ignored_by_productivity then
          v.ignored_by_productivity = (v.ignored_by_productivity or 0) - ingredient.ignored_by_productivity
        end
        if (v.amount and v.amount <= 0) or (v.amount_min and v.amount_max and v.amount_min <= 0 and v.amount_max <= 0) then
          table.remove(recipe.results, k)
        end
        break
      end
    end
  end
end

local function MultiplyRecipe(recipe, factor)
  if type(recipe) == "string" then
    recipe = misc.GetPrototype(recipe, "recipe")
    if not recipe then
      return
    end
  end
  rm.StandardizeRecipe(recipe)

  if type(factor) == "number" then
    factor = {input=factor, output=factor, time=factor}
  end

  local function MultiplyAttribute(dict, key, factor, default)
    if dict[key] then
      dict[key] = dict[key] * factor
    elseif default then
      dict[key] = default * factor
    end
  end

  if factor.input and recipe.ingredients then
    for k, v in pairs(recipe.ingredients) do
      MultiplyAttribute(v, 2, factor.input)
      MultiplyAttribute(v, "amount", factor.input)
      MultiplyAttribute(v, "ignored_by_stats", factor.input)
    end
  end

  if factor.output and recipe.results then
    for k, v in pairs(recipe.results) do
      MultiplyAttribute(v, 2, factor.output)
      MultiplyAttribute(v, "amount", factor.output)
      MultiplyAttribute(v, "amount_min", factor.output)
      MultiplyAttribute(v, "amount_max", factor.output)
      MultiplyAttribute(v, "ignored_by_stats", factor.output)
      MultiplyAttribute(v, "ignored_by_productivity", factor.output)
    end
  end

  if factor.time then
    MultiplyAttribute(recipe, "energy_required", factor.time, 0.5)
  end
end

local function ReplaceIngredientProportional(recipe, find, replace, factor, max)
  if type(recipe) == "string" then
    recipe = misc.GetPrototype(recipe, "recipe")
    if not recipe then
      return
    end
  end
  rm.StandardizeRecipe(recipe)

  if not factor then
    factor = 1
  end

  if not max then
    max = 99999
  end

  local amount_to_remove = math.min(GetIngredientCount(recipe, find), max)
  if amount_to_remove > 0 then
    RemoveIngredient(recipe, find, amount_to_remove)
    AddIngredient(recipe, replace, math.ceil(amount_to_remove * factor))
  end
end

local function AddRecipeCategory(recipe, category)
  if type(recipe) == "string" then
    recipe = data.raw.recipe[recipe]
  end
  if not recipe then
    return
  end
  if recipe.category == category then
    return
  end
  for k, v in pairs(recipe.additional_categories or {}) do
    if v == category then
      return
    end
  end

  if recipe.category == nil then
    recipe.category = category
  elseif recipe.additional_categories then
    table.insert(recipe.additional_categories, category)
  else
    recipe.additional_categories = {category}
  end
end

local function RemoveRecipeCategory(recipe, category)
  if type(recipe) == "string" then
    recipe = data.raw.recipe[recipe]
  end
  if not recipe then
    return
  end

  if recipe.category == category then
    recipe.category = nil
  end
  if recipe.additional_categories then
    local index = 1
    while index <= #recipe.additional_categories do
      if recipe.additional_categories[index] == category then
        table.remove(recipe.additional_categories, index)
        index = 1
      else
        index = index + 1
      end
    end
  end

  if recipe.category == nil then
    if recipe.additional_categories and #recipe.additional_categories > 0 then
      recipe.category = recipe.additional_categories[1]
      table.remove(recipe.additional_categories, 1)
    end
  end
end

local function AddLaserMillData(recipe, vanilla, dlc)
    if data.raw.recipe[recipe] then
        if vanilla then
            data.raw.recipe[recipe].lasermill_vanilla = vanilla
        end
        if dlc then
            data.raw.recipe[recipe].lasermill_dlc = dlc
        end
    end
end


rm.FindIngredientInList = FindIngredientInList
rm.StandardizeRecipe = StandardizeRecipe
rm.GetIngredientCount = GetIngredientCount
rm.AddIngredient = AddIngredient
rm.RemoveIngredient = RemoveIngredient
rm.AddProduct = AddProduct
rm.RemoveProduct = RemoveProduct
rm.ReplaceIngredientProportional = ReplaceIngredientProportional
rm.MultiplyRecipe = MultiplyRecipe
rm.AddRecipeCategory = AddRecipeCategory
rm.RemoveRecipeCategory = RemoveRecipeCategory
rm.AddLaserMillData = AddLaserMillData

return rm