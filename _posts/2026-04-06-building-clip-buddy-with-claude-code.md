---
title: "Building Clip Buddy with Claude Code"
source: "https://medium.com/@tom.5610/building-clip-buddy-with-claude-code-3dc078b068b4"
author:
  - "[[Tom Liu]]"
published: 2026-04-06
created: 2026-05-03
description: "More"
tags:
  - "clippings"
---
> This blog shares my experience building [Clip Buddy](https://github.com/tom5610/clip-buddy), backed by Lenny and Boris’s awesome podcast — [Head of Claude Code: What happens after coding is solved | Boris Cherny](https://www.youtube.com/watch?v=We7BZVKbCVw).
> 
> [Clip Buddy](https://github.com/tom5610/clip-buddy) takes any video URL, extracts the audio, transcribes it, and produces structured analysis — key arguments, speaker identification, and an interactive chat for deep-diving into specific topics.

## My Problem

One day, my account manager threw me a customer CEO’s podcast link, talking about their growth journey, business strategies, and technical challenges. I knew I had to listen. This was critical context for understanding their trajectory and potential needs. But between travel schedules and competing priorities, I knew I wouldn’t give it the deep attention it deserved.

I started thinking why not use AI to back me up, help me navigate the listening / watching journey, and coach me to deep-dive into clips collaboratively. That would be ideal, but I couldn’t find any tools doing exactly that. Hence, I wanted to build one, maybe with Claude Code?

## The Engineer’s Paradox: 17+ Years of “Proper” Engineering

But I believe in craftsmanship. I have 17 years of backend development experience. I built systems the “right way” — choosing language(s) carefully, selecting tech stacks thoughtfully, designing POCs methodically. I knew these choices would paralyze me — and they did.

I had the idea. I had the outcome I wanted. But the process felt like climbing a mountain just to start.

I knew Claude Code may be useful, but I was so reluctant to give it a shot because of my concerns:

- Would it rob me of the joy of building?
- Would I end up shipping something I didn’t actually understand?
- Would I just become a prompt engineer rather than a real engineer?

Then I heard Boris talk about the printing press analogy (FYI — [reference clip timestamp](https://www.youtube.com/watch?v=We7BZVKbCVw&t=1959s)).

## The Turning Point: The Printing Press Analogy

Boris described how the printing press transformed literacy:

**Before**:  
Literacy was ~1% globally (mostly scribes who manually copied texts)

**After**:  
Literacy expanded to ~70% in about 50 years

But here’s the part that struck me: the printing press didn’t make scribes obsolete. It freed them from manual copying so they could focus on craft — on thinking about what they were copying rather than just copying it.

A scribe might have worried: “Will the printing press steal my job? Will I stop being a craftsman?”

The answer was no. Scribes who adopted the printing press became more valuable, not less. They could focus on editing, translating, designing beautiful layouts — the meaningful work. As Boris put it, “in the 50 years after the printing press was built, there was more printed material created than in the 1,000 years before.” ([reference clip timestamp](https://www.youtube.com/watch?v=We7BZVKbCVw&t=2002)) The tool didn’t diminish output — it multiplied it.

Something shifted in my mind.

Maybe Claude Code wasn’t about speed. Maybe it was about democratization freeing me to stop worrying about boilerplate & tech stack selection, and start focusing on thinking — on the architecture, the user experience, the learning.

If scribes could use the printing press to free time from manual copying and focus on craft, then maybe I could use Claude Code to free time from tedious implementation and focus on building something I understand deeply.

I decided to try.

## The Workflow: Three Steps That Changed Everything

In the podcast, Boris emphasized always using the most capable model, not boxing the model in, and leveraging Plan Mode. In addition, he envisioned a near-term future where traditional role boundaries dissolve — ‘software engineer’ gives way to ‘builder’.

Could a tool really shift that identity? Here’s the workflow that changed my mind.

## Step 1: Start with Outcome, Not Specs (yet)

I started with the following prompt on the app development, with Claude Code coaching me to drive a clear outcome:

> Hi Claude, please brainstorm with me without writing any code. Strictly follow a structured process to inspire me to clarify business value and requirements of an application. Remember one question at a time. Once we finish, please summarize our discussion and requirements into ‘./doc/uclip-intro.md’. Let’s start.

Notice what I didn’t do:

- Didn’t specify features (“build audio download, transcripts, and chat”)
- Didn’t prescribe a tech component / stack (“use Python with FastAPI”)
- Didn’t write step-by-step instructions (“first do X, then do Y”)

I used Plan Mode to steer collaborative iteration before execution, then auto-accepted edits to produce the product intro in one shot.

Claude Code asked clarifying questions:

- Who are the users? (Me, busy professionals)
- What’s the core objective? (Extract insights efficiently; deep-dive on specific topics)
- What interactions do users need? (Summary, argument flow, structural insights, real-time Q&A)
- What technical constraints exist? (I don’t need to scale to millions; I need something I can iterate on fast)
- What technical components are being used? (python, streamlit with yt-dlp package, etc.)

As we discussed, Claude Code designed the product intro, which I used as the basis for a more detailed design spec, and tried Plan Mode to produce a draft.

**Key insight**: By not boxing Claude Code in with prescriptive steps, it could reason about the full picture — user needs, architecture, scalability — and propose something more coherent than I would have in isolation.

## Step 2: Iterate on Outcomes, Not Code

While Claude Code may generate surprisingly strong results, the real unlock is iterating on outcomes, not code.

The initial implementation of Chat function (the feature allowing users to chat with AI on the clip content) was not useful — the interaction was not conversational style and each turn could take 20–30s, e.g. when I asked for “brainstorm a problem, one question at a time”, Chat function threw multiple questions at once, rather than one at a time. Likely the system prompt and prompt template in Chat function weren’t good enough. Instead of jumping to solutions, I collaborated with Claude Code to understand the problem first.

Then, I used this outcome-focused feedback:

> In the Chat function, I tried to guide the chat service to collaborate with me one question at a time, but it responds with a bunch of questions. Could you please review the chat prompt and analyze what I may improve? Please don’t implement any solutions, but collaborate with me, help me understand, until I confirm to implement it.

Notice what I did here:

- Described the outcome I wanted (one question at a time)
- Described the current behavior (bunch of questions)
- Asked Claude Code to analyze, not execute (“don’t implement”)
- Invited collaboration (help me understand)

Claude Code helped me think through the UX philosophy. I learned why one question at a time matters for conversational flow. When I was happy with the collaborative suggestion, I let Claude Code act on it.

In addition, it turned out the initial implementation passed the entire transcript as context. What a naive approach! Maybe I could ask it to brainstorm with me on better options, but I paused and reflected how I actually converse with people — listening first, understanding intent, then responding. Could Chat function do the same? I tried this:

> Would it be possible to review the user’s question, clarify the intention, then decide what context we need to provide to answer the question / coach the user? THINK HARD on this. Don’t implement anything until my confirmation.

Claude Code redesigned the entire chat flow:

**Before**:  
User asks question → Retrieve entire transcript as context → LLM generates response (slow, generic)

**After**:  
User asks question → Intention discovery → Context construction (retrieve only relevant parts for the intention) → LLM invocation → Answer (fast, targeted, collaborative)

This redesign taught me more about systems thinking than I expected. This kind of insight felt more natural when arrived at collaboratively than when designed in isolation.

Meanwhile, the redesign improved latency. Rather than putting entire transcript as context, it became frugal with context usage and achieved faster response each turn.

Overall, the chat changed everything about the user experience, from a Q&A function to a thoughtful interaction: Question → Intention Discovery → Context Construction → LLM Invocation → Answer.

**Key insight**: My building process is to collaborate with Claude Code and iterate on outcomes, rather than coding.

## Step 3: When It Breaks: Collaborate, Don’t Command

Over the app building process, not every session was smooth — Claude Code sometimes went in circles on edge cases, and I had to learn when to reset context vs. push forward.

Hence, I managed context carefully. On one hand, once I finished a task, I always used ‘/clear’ to clear up the session so that I could start a brand-new conversation on the next. I wanted to keep it simple and avoid unnecessary context pollution. On the other hand, working on context is interesting. Given Claude models are so good at using tools, very often Claude Code could use bash commands to find information / context to complete tasks autonomously. However, there were some edge cases.

There was a bug when doing speaker identification in ‘Deep Dive’ analysis, and it prompted “Expecting value: line 1 column 1 (char 0)”. I took it easy and just asked Claude Code to “please investigate the error” with the error message. Claude Code worked like a charm — it formed a structured process to resolve the bug, and confirmed the fix worked. Everything sounded perfect, but the fix didn’t work at all. Next, I tried to be patient — “your fix doesn’t work, please investigate again”. Then, Claude Code worked harder but didn’t deliver any proper fixes…

Maybe not every session was as smooth as steps 1 & 2 suggest. I got frustrated, and kept asking Claude Code to “FIX It…”. Guess what?! The bug still existed.

So I did what most frustrated engineers do — I kept slamming the same button. Then, I heard this voice in my mind — “Ask not what the model can do for you”, from Boris ([reference clip timestamp](https://www.youtube.com/watch?v=We7BZVKbCVw&t=3857s)). Maybe I should “ask what I can do for the model”?! First, I googled the error message, but I couldn’t get much useful information. Then, I decided to collaborate with Claude Code to know more -

> your fix doesn’t work, could you please analyze the issue and explain what may be missed. If you need more information for the investigation, please let me know.

This one did change the game a bit. Claude Code shifted to focus on analyzing the problem (but not implementing the fix). It nailed down the culprit as an empty string being parsed by JSON. Then, where was the empty string from and what was that for? While reading the code, I started realizing that the function made an LLM call to identify speakers — the system prompt had a dedicated instruction for multi-speaker transcript — “You are analyzing a multi-speaker transcript to identify speakers …”. However, when I tried to analyze a single-speaker clip, the LLM call returned an empty string instead of proper JSON, and resulted in the JSON parsing error.

I tuned the prompt template to support single-speaker clip explicitly, and gave this instruction to improve further -

> The speaker identification fails on single-speaker videos — the model seems confused when there’s only one speaker label. I think the prompt saying ‘multi-speaker transcript’ is misleading it. Can you fix the prompt to handle both single and multi-speaker cases?

Claude Code did better prompt engineering — being specific and direct on return value — “Always return the JSON array even if there is only one speaker.” Surely, the fix worked perfectly.

**Key insight**: When Claude Code fails, the fix is usually better context, not more pressure.

## Not the End, But a New Builder Path

Remember that CEO podcast I couldn’t properly digest? It was a 53-minute podcast with 2 hosts and the CEO. It took me about 10 minutes to run through [Clip Buddy](https://github.com/tom5610/clip-buddy); in addition, I conducted an in-depth chat session to explore the business strategy and planning, then shared the analysis with my account manager. He was thrilled.

Did Claude Code rob me of the joy of building? No — the joy shifted from typing to thinking. Did I ship something I didn’t understand? I understand it more deeply than most code I’ve written, because I had to articulate my intent clearly enough for a collaborator to act on it. Am I just a prompt engineer? No — I’m still the architect. Claude Code is the printing press.

That’s not the end, but it paved a new path for me to build, to learn from, and to collaborate with Claude Code.
