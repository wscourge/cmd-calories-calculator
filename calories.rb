require 'tty-prompt'
require 'tty-table'

INTENSITY_CHOICES = [
  { name: '1.0: lying or sedentary lifestyle, lack of physical activity', value: 1.0 },
  { name: '1.2: sedentary work, low level physical activity', value: 1.2 },
  { name: '1.4: not physical work, training twice a week', value: 1.4 },
  { name: '1.6: light physical work, training 3-4 times a week', value: 1.6 },
  { name: '1.8: physical work, training 5 times a week', value: 1.8 },
  { name: '2.0: hard physical work, daily training', value: 2.0 }
]
# Building mass
MASS_GAIN = {
  ekto: 1.2,
  mezo: 1.15,
  endo: 1.10
}

# Keeping current weight
MAINTAIN_MASS = {
  ekto: 1.0,
  mezo: 1.0,
  endo: 1.0
}
  
# Fat reduction
REDUCE_MASS = {
  ekto: 0.9,
  mezo: 0.85,
  endo: 0.8
}

BODY_TYPES = [
  { name: 'Ectomorph (slim)', value: :ekto },
  { name: 'Endomorph (massive)', value: :endo },
  { name: 'Mezomorph (muscular)', value: :mezo },
]

TARGETS = [
  { name: 'Mass gain', value: MASS_GAIN },
  { name: 'Maintain', value: MAINTAIN_MASS },
  { name: 'Reduction', value: REDUCE_MASS }
]

weight = TTY::Prompt.new.ask('Weight (kg)').to_f
height = TTY::Prompt.new.ask('Height (cm)').to_f
age = TTY::Prompt.new.ask('Age (years)').to_i
intensity = TTY::Prompt.new.select('Intensity', INTENSITY_CHOICES)
body_type = TTY::Prompt.new.select('Body type', BODY_TYPES)
target = TTY::Prompt.new.select('Targets', TARGETS)

bmr = 66.5 + (13.7 * weight) + (5 * height) - (6.8 * age)

kcal = target[body_type] * bmr * intensity
protein_grams = 2.2 * weight
protein_calories = protein_grams * 4
protein_percentage = protein_calories / kcal * 100
fat_calories = 0.2 * kcal
fat_grams = fat_calories / 9
fat_percentage = fat_calories / kcal * 100
carbs_calories = kcal - fat_calories - protein_calories
carbs_grams = carbs_calories / 4
carbs_percentage = carbs_calories / kcal * 100
total_grams = carbs_grams + fat_grams + protein_grams

puts TTY::Table.new(
  ['Macro', 'Kcal', 'Grams', 'Percentage'],
  [
    ['Fats', fat_calories.round(2), fat_grams.round(2), fat_percentage.round(2)],
    ['Proteins', protein_calories.round(2), protein_grams.round(2), protein_percentage.round(2)],
    ['Carbs', carbs_calories.round(2), carbs_grams.round(2), carbs_percentage.round(2)],
    ['Total', kcal.round(2), total_grams.round(2), 100]
  ]
).render(:ascii)
