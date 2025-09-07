import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.stats.proportion import proportion_confint

df = pd.read_csv('', sep = '\t', index_col=0)

conf_level = 0.95    
alpha = 1 - conf_level


results = []
for name, row in df.iterrows():
    k, n = row["cases"], row["total"]
    est = k / n
    lower, upper = proportion_confint(k, n, alpha=alpha, method="beta")
    results.append([est, lower, upper])

df_out = df.copy()
df_out[["estimate", "lower", "upper"]] = results
df_out[["estimate", "lower", "upper"]] *= 100  # convert to %


plt.figure(figsize=(7, 5))
plt.bar(df_out.index, df_out["estimate"], color="steelblue", alpha=0.8)
plt.errorbar(
    df_out.index,
    df_out["estimate"],
    yerr=[df_out["estimate"] - df_out["lower"], df_out["upper"] - df_out["estimate"]],
    fmt="none",
    ecolor="black",
    capsize=4
)

plt.ylabel("Cases (%)")
plt.title(f"Proportion of Cases with {int(conf_level*100)}% CI (Beta)")
plt.xticks(rotation=45, ha="right")
plt.tight_layout()
plt.show()
