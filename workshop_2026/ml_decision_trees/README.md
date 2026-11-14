# Concepts and Code: Decision Trees
This repository contains the files associated with the StatQuest "Concepts and Code" livestream for [Decision Trees](https://youtube.com/live/z6V3keTibCA). BAM!

NOTE: 
One mistake was fixed from the original repo:
The `force_int_remainder_cols` argument was added in a newer scikit-learn release than the one installed in the `.venv`. The argument only controls how the remainder column names are stored, so removing it doesn't change the model. The fix is to delete `, force_int_remainder_cols=False` from that line.

There's also a pandas warning from line 37. In pandas 3, text columns use a `str` dtype, so `select_dtypes(include="object")` and `exclude="object"` don't handle them consistently. Here it gave 3 categorical and 11 numeric columns, which adds up to the 14 predictors, so nothing is lost. Passing `"str"` explicitly, as the warning suggests, would silence it and make the split more robust.