-- -*-haskell-*-
--  GIMP Toolkit (GTK) @entry Widget Combo@
--
--  Author : Axel Simon
--          
--  Created: 2 June 2001
--
--  Version $Revision: 1.2 $ from $Date: 2002/05/24 09:43:25 $
--
--  Copyright (c) 1999..2002 Axel Simon
--
--  This file is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This file is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
-- @description@ --------------------------------------------------------------
--
-- * A Combo box is a text entry field with a drop down list of predefined
--   alternatives.
--
-- @documentation@ ------------------------------------------------------------
--
-- * The Combo widget allows to insert arbitrary widgets as alternatives. Due
--   to the deprecated ListItem object we currently make no use of this 
--   feature.
--
-- @todo@ ---------------------------------------------------------------------
--
-- * The combo_set_item_string function is not bound as we do not handle
--   arbitrary widgets yet.
--
module Combo(
  Combo,
  ComboClass,
  castToCombo,
  comboNew,
  comboSetPopdownStrings,
  comboSetValueInList,
  comboSetUseArrows,
  comboSetUseArrowsAlways,
  comboSetCaseSensitive,
  comboDisableActivate
  ) where

import Monad	(liftM, mapM_)
import Foreign
import UTFCForeign
import Object	(makeNewObject)
import Widget	(widgetShow)
import Container(containerAdd)
{#import Hierarchy#}
{#import Signal#}
import Structs	(comboGetList)

{# context lib="gtk" prefix="gtk" #}

-- methods

-- Create a new Combo text entry field.
--
comboNew :: IO Combo
comboNew = makeNewObject mkCombo $ liftM castPtr $ {#call unsafe combo_new#}

-- @method comboSetPopdownStrings@ Insert a set of Strings into the
-- @ref type Combo@ drop down list.
--
comboSetPopdownStrings :: ComboClass c => c -> [String] -> IO ()
comboSetPopdownStrings c strs = do
  list <- comboGetList (toCombo c)
  {#call list_clear_items#} list  0 (-1)
  mapM_ (\str -> do
    li <- makeNewObject mkWidget $ liftM castPtr $ 
      withCString str {#call unsafe list_item_new_with_label#}
    widgetShow li
    containerAdd list li)
    strs

-- @method comboSetValueInList@ Specify whether the user may enter texts that
-- are not in the list of alternatives and if empty entries are allowed.
--
comboSetValueInList :: ComboClass c => c -> Bool -> Bool -> IO ()
comboSetValueInList c val okIfEmpty = {#call unsafe combo_set_value_in_list#}
  (toCombo c) (fromBool val) (fromBool okIfEmpty)

-- @method comboSetUseArrows@ Specify if the user may use the cursor keys to
-- navigate the list.
--
comboSetUseArrows :: ComboClass c => c -> Bool -> IO ()
comboSetUseArrows c val = {#call unsafe combo_set_use_arrows#} (toCombo c)
  (fromBool val)

-- @method comboSetUseArrowsAlways@ Specify if the content entered by the user
-- will be replaced by a predefined alternative as soon as the user uses the
-- cursor keys.
--
comboSetUseArrowsAlways :: ComboClass c => c -> Bool -> IO ()
comboSetUseArrowsAlways c val = {#call unsafe combo_set_use_arrows_always#}
  (toCombo c) (fromBool val)

-- @method comboSetCaseSensitive@ Specify whether the entered text is case
-- sensitive when it comes to matching the users input with the predefined
-- alternatives.
--
comboSetCaseSensitive :: ComboClass c => c -> Bool -> IO ()
comboSetCaseSensitive c val = {#call unsafe combo_set_case_sensitive#}
  (toCombo c) (fromBool val)

-- @method comboDisableActivate@ Stops the GtkCombo widget from showing the
-- popup list when the Entry emits the "activate" signal, i.e. when the Return
-- key is pressed. This may be useful if, for example, if you want the Return
-- key to close a dialog instead.
--
comboDisableActivate :: ComboClass c => c -> IO ()
comboDisableActivate  = {#call unsafe combo_disable_activate#}.toCombo

