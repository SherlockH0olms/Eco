# 🚀 Quick Start Guide

## 5-Minute Setup

### 1. Clone & Install (2 min)

```bash
git clone https://github.com/SherlockH0olms/Eco.git
cd Eco
flutter pub get
```

### 2. Run on Device (2 min)

```bash
# Connect your phone via USB
# Enable USB debugging on Android

flutter run
```

### 3. Grant Permissions (1 min)

- Allow camera access when prompted
- Position phone 1.5-2m away
- Ensure good lighting

## 📱 First Time User Flow

1. **Home Screen**
   - Tap "Arm Raise Game"

2. **Game Screen**
   - Stand in front of camera
   - Raise arms when you see bubbles
   - Pop 10 bubbles to complete

3. **Dashboard**
   - Tap "View Progress" on home
   - See your stats and charts

## 🎯 Demo Preparation (Hackathon)

### Equipment Needed
- 📱 Android/iOS phone (not emulator!)
- 📦 Phone stand or tripod
- 💡 Good lighting (window or lamp)
- 🖼️ Plain background (wall)

### Setup (10 minutes before demo)

1. **Position phone**:
   - 1.5-2 meters from demo area
   - Chest height
   - Landscape orientation optional

2. **Test lighting**:
   - Face towards light source
   - Avoid backlight (window behind you)
   - Ensure full body visible

3. **Prepare data**:
   - Do 2-3 practice sessions
   - Generate some dashboard data
   - Or use demo mode (if implemented)

4. **Wear appropriate clothes**:
   - Contrasting colors (not all black/white)
   - Short sleeves (easier tracking)
   - Avoid patterns

### Demo Script (2 minutes)

**0:00-0:30 - Problem**
> "SMA patients need daily physio, but it's boring and expensive. 
> Parents can't track progress objectively."

**0:30-1:30 - Demo**
> "Watch this - [do arm raises, pop bubbles]
> See the green feedback? The AI confirms correct form.
> [Show score increasing]"

**1:30-1:50 - Dashboard**
> "Parents see progress here - sessions, form quality, trends.
> All stored locally, works offline, zero cost."

**1:50-2:00 - Vision**
> "We're starting with SMA, expanding to all neuro rehab.
> Making therapy accessible and fun for every child."

## ⚡ Troubleshooting

### Camera not working
```bash
# Check permissions
adb shell pm grant com.sma.physio.game android.permission.CAMERA

# Or manually in Settings > Apps > SMA Physio Game > Permissions
```

### Pose not detected
- Ensure full upper body visible
- Improve lighting
- Move closer to camera
- Restart app

### App crashes
```bash
flutter clean
flutter pub get
flutter run
```

### Lag/slow performance
- Use physical device (not emulator)
- Close other apps
- Reduce camera resolution in code
- Ensure phone is charged

## 📝 Pre-Demo Checklist

- [ ] Phone fully charged (90%+)
- [ ] Camera permission granted
- [ ] App tested in demo location
- [ ] Lighting verified
- [ ] Background clear
- [ ] Practice data generated
- [ ] Backup device ready
- [ ] Pitch memorized
- [ ] Q&A answers prepared
- [ ] Team roles assigned

## 🏆 Demo Tips

1. **Start confident**: "Let me show you how it works"
2. **Explain while doing**: Narrate your actions
3. **Show real results**: Point to score/feedback
4. **Emphasize key points**: "Zero cost", "Works offline"
5. **End with impact**: "Helping thousands of families"

## 💬 Q&A Prep

**Q: Can it work with wheelchairs?**
A: Yes! Seated exercises supported. Camera adjusts to visible body parts.

**Q: What about data privacy?**
A: All data local. No cloud upload. No video saved unless user chooses.

**Q: How accurate compared to therapist?**
A: 90%+ joint tracking. Not replacing therapists - empowering daily practice.

**Q: What's next after hackathon?**
A: Clinical trials, more exercises, cloud sync, therapist portal.

---

## Need Help?

- 🐛 Report bugs: [GitHub Issues](https://github.com/SherlockH0olms/Eco/issues)
- 💬 Ask questions: [GitHub Discussions](https://github.com/SherlockH0olms/Eco/discussions)
- 📧 Contact team: [Open an issue](https://github.com/SherlockH0olms/Eco/issues/new)

**Good luck with your demo! 🎉**
