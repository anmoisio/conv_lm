# coding: utf-8
from transformers import BertTokenizer, AutoModelForSequenceClassification, TrainingArguments, Trainer
import numpy as np
from datasets import load_metric
from datasets import load_dataset
from torch.utils.data import DataLoader

lm_train = "/scratch/work/moisioa3/conv_lm/data/lm-train/dsp.txt"
lm_devel = "/scratch/work/moisioa3/conv_lm/data/devel/plain.txt"

tokenizer = BertTokenizer.from_pretrained("TurkuNLP/bert-base-finnish-cased-v1")

with open(lm_train, 'r', encoding='utf-8') as f:
    train_data = tokenizer(f.readlines(), padding="max_length", truncation=True)
with open(lm_devel, 'r', encoding='utf-8') as f:
    devel_data = tokenizer(f.readlines(), padding="max_length", truncation=True)

# small_train_dataset = train_data.shuffle(seed=42).select(range(1000))
# small_eval_dataset = devel_data.shuffle(seed=42).select(range(1000))
full_train_dataset = train_data
full_eval_dataset = devel_data

model = AutoModelForSequenceClassification.from_pretrained(
    "TurkuNLP/bert-base-finnish-cased-v1",
    num_labels=2
    )
training_args = TrainingArguments(
    "test_trainer",
    evaluation_strategy="epoch"
    )
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=full_train_dataset,
    eval_dataset=full_eval_dataset
    )

metric = load_metric("accuracy")

def compute_metrics(eval_pred):
    logits, labels = eval_pred
    predictions = np.argmax(logits, axis=-1)
    return metric.compute(predictions=predictions, references=labels)

trainer.train()
