# coding: utf-8
from transformers import BertTokenizer, AutoModelForSequenceClassification, AdamW, get_linear_schedule_with_warmup
from torch.utils.data import DataLoader
import torch
from tqdm.auto import tqdm

lm_train = "/scratch/work/moisioa3/conv_lm/data/lm-train/dsp.txt"
lm_devel = "/scratch/work/moisioa3/conv_lm/data/devel/plain.txt"

tokenizer = BertTokenizer.from_pretrained("TurkuNLP/bert-base-finnish-cased-v1")

with open(lm_train, 'r', encoding='utf-8') as f:
    train_data = tokenizer.encode(f.readlines(), padding="max_length", truncation=True)
with open(lm_devel, 'r', encoding='utf-8') as f:
    devel_data = tokenizer.encode(f.readlines(), padding="max_length", truncation=True)

train_dataloader = DataLoader(train_data, shuffle=True, batch_size=8)
eval_dataloader = DataLoader(devel_data, batch_size=8)

model = AutoModelForSequenceClassification.from_pretrained(
    "TurkuNLP/bert-base-finnish-cased-v1"
    )

optimizer = AdamW(model.parameters(), lr=5e-5)

num_epochs = 3
num_training_steps = num_epochs * len(train_dataloader)
lr_scheduler = get_linear_schedule_with_warmup(
    optimizer=optimizer,
    num_warmup_steps=0,
    num_training_steps=num_training_steps
)

device = torch.device("cuda") if torch.cuda.is_available() else torch.device("cpu")
model.to(device)

progress_bar = tqdm(range(num_training_steps))

model.train()
for epoch in range(num_epochs):
    for batch in train_dataloader:
        batch = {k: v.to(device) for k, v in batch.items()}
        outputs = model(**batch)
        loss = outputs.loss
        loss.backward()

        optimizer.step()
        lr_scheduler.step()
        optimizer.zero_grad()
        progress_bar.update(1)