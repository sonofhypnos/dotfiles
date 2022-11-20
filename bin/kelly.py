#!/usr/bin/env python3
import os
import pandas as pd
import matplotlib.pyplot as plt
import sys
import argparse

parser = argparse.ArgumentParser(
    prog="kelly",
    description="Calculate the optimal bet size for a given bankroll, odds, and probability.",
)
# parse command line arguments
# if len(sys.argv) < 5:
#     odds, bankroll = sys.argv[1:]
#     bankroll = int(bankroll)
#     lower = 0
#     upper = 100
# else:
#     odds, bankroll, lower, upper = sys.argv[1:]  # lower and upper in percent
#     bankroll = int(bankroll)
#     lower = int(lower)
#     upper = int(upper)

# parse command line arguments
parser.add_argument("bankroll", type=int, help="odds")
odds_group = parser.add_mutually_exclusive_group(required=True)
odds_group.add_argument("-o", "--odds", type=float, help="winning/loosing price")
odds_group.add_argument(
    "-p", "--probability", type=float, help="probability (implicit odds)"
)
parser.add_argument("-l", "--lower", type=int, help="odds")
parser.add_argument("-u", "--upper", type=int, help="odds")

args = parser.parse_args()

bankroll = args.bankroll
probability = args.probability
odds = args.odds
lower = args.lower
upper = args.upper

if not lower:
    lower = 0
if not upper:
    upper = 100
if probability:
    odds = probability / (1 - probability)
if odds:
    probability = odds / (odds + 1)


# plot optimal Kelly bet
def kelly(bankroll, odds, probability):
    """Calculate the optimal bet size for a given bankroll, odds, and probability."""
    return bankroll * (odds * probability - (1 - probability)) / odds


pd.Series([kelly(bankroll, odds, 0.01 * i) for i in range(lower, upper)]).plot()
plt.grid(visible=True)
plt.xlabel("Subjective Probability in %")
plt.ylabel("M$ to bet (negative means bet on NO)")
plt.title(f"Kelly bet on Bet with probability {probability} and implied odds {odds}")
plt.savefig("kelly.png")
os.system("xdg-open kelly.png")
