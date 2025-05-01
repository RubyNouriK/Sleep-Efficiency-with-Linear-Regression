# Investigating Sleep Efficiency with Linear Regression 

This Project was completed as a gorup project for the University of Calgary course DATA603 - Statistical Modelling with Data.

## Introduction

Sleep is a fundamental biological need for humans, as highlighted in Maslow’s hierarchy of needs. However, sleep alone is not sufficient; it must be efficient. 
Sleep efficiency refers to the proportion of time spent actually sleeping while in bed. 
Understanding sleep efficiency is critical because poor sleep quality can negatively impact individuals across multiple dimensions, including cognitive, emotional, and physical health.

The primary problem this project aims to address is identifying the key factors that influence sleep efficiency and understanding how these factors interact to affect sleep quality. 

This problem is challenging because everyone’s sleep schedule and habits are different, so we might encounter barriers when trying to create a model that accurately predicts sleep efficiency for everyone. 

By identifying the factors that influence sleep efficiency, we can provide evidence-based recommendations to help individuals improve their sleep quality and, consequently, their overall quality of life.

## Dataset

The dataset was obtained from Kaggle which is free to use for project purposes. The dataset contains various factors affecting the sleep efficiency listed in different columns.

1. **Age**: The participant’s age. Sleep habits and quality might change as a person gets older.

2. **Gender**: A person’s gender. We will investigate if different genders have different patterns in sleep efficiency.

3. **Bedtime**: The time at which a person goes to bed. It is a key part of the body’s natural circadian rhythm.

4. **Wake-up time**: The time a person wakes up. This can disrupt sleep cycles if it is inconsistent or too early.

5. **Sleep duration**: The amount of time spent sleeping. Both insufficient and excessive sleep can harm sleep quality.

6. **REM sleep**: The percentage of total sleep that is REM sleep. It is crucial for cognitive restoration and emotional regulation.

7. **Deep sleep**: The percentage of total sleep that is deep sleep. This phase is essential for physical recovery and immune function.

8. **Light sleep**: The percentage of total sleep that is light sleep. While less restorative, light sleep still plays a role in transitioning between sleep stages.

9. **Awakenings**: The number of times a participant awoke during the night. Frequent awakenings during the night can fragment the sleep stages.

10. **Caffeine consumption**: Amount of caffeine consumed (mg) 24-hour before bedtime. Caffeine could keep someone awake longer than necessary and disrupt their circadian rhythm.

11. **Alcohol consumption**: Amount of alcohol consumed (oz) in the 24-hour before bedtime. Alcohol could keep someone awake longer than necessary and disrupt their circadian rhythm.

12. **Smoking status**: Whether the participant smokes or not. Nicotine is a stimulant that can interfere with falling asleep and staying asleep.

13. **Exercise frequency**: The number of times a participant exercises in a week. Regular physical activity has been shown to reduce stress and improve sleep quality.

14. **Sleep Efficiency**: This will be the response variable, is quantitative, and as stated in the project proposal is measured in percentage. Given there are no values collected as 0 or 100, and the values close to 100 represent less than 3% of the records within the dataset , we see it is viable to try to model the sleep efficiency in this project.

![image](Figures/1.Table-dataset.jpg)

## Results





## Conclusion

The analysis conducted provides promising insights into how various lifestyle and physiological factors influence sleep efficiency, even if the model is not perfectly suited for individual-level predictions. The final model explains **85.44**% of the variance in sleep efficiency, highlighting key influences such as exercise, alcohol, smoking, age, awakenings, and deep sleep percentage.

Alcohol consumption and smoking both demonstrate negative effects on sleep efficiency, with smoking showing a particularly strong detrimental impact. These findings align with existing medical research about substance use and sleep quality. Interestingly, while smoking generally reduces sleep efficiency, the model suggests deep sleep may slightly mitigate this effect, possibly due to nicotine's temporary relaxing properties.

The relationship between age and sleep efficiency proves complex, following a **nonlinear pattern** that changes across different life stages. This likely reflects how various life circumstances and health factors influence sleep differently at various ages, rather than being solely caused by biological aging itself.

Sleep architecture plays a crucial role in sleep efficiency. *REM sleep* shows a clear positive association with better sleep quality, supporting its importance for cognitive restoration. *Deep sleep* presents a more nuanced relationship, where moderate amounts are beneficial but excessive duration may become counterproductive, indicating balance is key.

The unexpected positive association between nighttime awakenings and sleep efficiency warrants further investigation. While initially counterintuitive, this effect is likely explained by the negative offset provided by the interaction between awakenings and deep sleep percentage. Individuals who are able to achieve a large percentage of deep sleep seem to be less affected by awakenings since they can still achieve enough deep sleep. The positive interpretation of awakenings might also suggest measurement limitations in the study design.




## Refrences

* Deng, Z., Liu, L., Liu, W., Liu, R., Ma, T., Xin, Y., Xie, Y., Zhang, Y., Zhou, Y., & Tang, Y. (2024). Alterations in the fecal microbiota of methamphetamine users with bad sleep quality during abstinence. BMC Psychiatry, 24(1), 324-12. https://doi.org/10.1186/s12888-024-05773-5

* ENSIAS. (2021). Sleep Efficiency Dataset. Kaggle. Retrieved [March 11, 2025], from https://www.kaggle.com/datasets/equilibriumm/sleep-efficiency/data 

* Fjell, A. M., Sørensen, Ø., Wang, Y., Amlien, I. K., Baaré, W. F. C., Bartrés-Faz, D., Boraxbekk, C., Brandmaier, A. M., Demuth, I., Drevon, C. A., Ebmeier, K. P., Ghisletta, P., Kievit, R., Kühn, S., Madsen, K. S., Nyberg, L., Solé-Padullés, C., Vidal-Piñeiro, D., Wagner, G., . . . Walhovd, K. B. (2023). Is short sleep bad for the brain? brain structure and cognitive function in short sleepers. The Journal of Neuroscience, 43(28), 5241-5250. https://doi.org/10.1523/JNEUROSCI.2330-22.2023

* Maslow, A. H. (1943). A theory of human motivation. Psychological Review, 50(4), 370-396.

* Pan, L., Li, L., Peng, H., Fan, L., Liao, J., Wang, M., Tan, A., & Zhang, Y. (2022). Association of depressive symptoms with marital status among the middle-aged and elderly in rural china: Serial mediating effects of sleep time, pain and life satisfaction. Journal of Affective Disorders, 303, 52-57. https://doi.org/10.1016/j.jad.2022.01.111

* Wang, L., & Aton, S. J. (2022). Perspective – ultrastructural analyses reflect the effects of sleep and sleep loss on neuronal cell biology. Sleep (New York, N.Y.), 45(5), 1. https://doi.org/10.1093/sleep/zsac047
