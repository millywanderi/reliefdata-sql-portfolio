#!usr/bin/env python3


from pathlib import Path
import re

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import mm
from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    Spacer,
    Image,
    Table,
    TableStyle,
    PageBreak,
)

ROOT = Path(__file__).resolve().parent.parent
REPORT = ROOT / "docs" / "case_study_report.md"
OUTPUT = ROOT / "docs" / "ReliefData_Case_Study_Report.pdf"

CHARTS = {
    "warehouse_capacity.png",
    "inventory_vs_minimum.png",
    "distribution_by_item.png",
}

styles = getSampleStyleSheet()
styles.add(ParagraphStyle(
    name="ReportTitle",
    parent=styles["Title"],
    fontName="Helvetica-Bold",
    fontSize=22,
    leading=28,
    alignment=TA_CENTER,
    textColor=colors.HexColor("#17365D"),
    spaceAfter=12,
))
styles.add(ParagraphStyle(
    name="SectionHeading",
    parent=styles["Heading1"],
    fontSize=15,
    leading=19,
    textColor=colors.HexColor("#17365D"),
    spaceBefore=12,
    spaceAfter=7,
    keepWithNext=True,
))
styles.add(ParagraphStyle(
    name="SubHeading",
    parent=styles["Heading2"],
    fontSize=11,
    leading=14,
    textColor=colors.HexColor("#287271"),
    spaceBefore=8,
    spaceAfter=5,
    keepWithNext=True,
))
styles.add(ParagraphStyle(
    name="BodyCustom",
    parent=styles["BodyText"],
    fontSize=9,
    leading=13,
    spaceAfter=6,
))
styles.add(ParagraphStyle(
    name="CaptionCustom",
    parent=styles["BodyText"],
    fontSize=8,
    leading=10,
    alignment=TA_CENTER,
    textColor=colors.HexColor("#555555"),
    spaceAfter=10,
))
styles.add(ParagraphStyle(
    name="BulletCustom",
    parent=styles["BodyText"],
    fontSize=9,
    leading=12,
    leftIndent=14,
    firstLineIndent=-8,
    spaceAfter=4,
))

def escape(text):
    """Escape text for ReportLab paragraphs."""
    text = text.replace("&", "&amp;")
    text = text.replace("<", "&lt;")
    text = text.replace(">", "&gt;")
    return text

def inline_markup(text):
    """Convert a small subset of Markdown inline formatting."""
    text = escape(text)
    text = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", text)
    text = re.sub(r"\*(.+?)\*", r"<i>\1</i>", text)
    text = re.sub(r"`(.+?)`", r"<font name='Courier'>\1</font>", text)
    return text

def footer(canvas, doc):
    canvas.saveState()
    canvas.setStrokeColor(colors.HexColor("#D9E2F3"))
    canvas.line(20 * mm, 15 * mm, 190 * mm, 15 * mm)
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(colors.HexColor("#666666"))
    canvas.drawString(20 * mm, 10 * mm, "ReliefData | Fictional portfolio case study")
    canvas.drawRightString(190 * mm, 10 * mm, f"Page {doc.page}")
    canvas.restoreState()

def add_chart(story, filename, caption):
    path = ROOT / "docs" / filename
    if not path.exists():
        story.append(Paragraph(
            f"[Chart not found: {filename}]",
            styles["BodyCustom"],
        ))
        return

    image = Image(str(path))
    image._restrictSize(165 * mm, 100 * mm)
    image.hAlign = "CENTER"
    story.append(Spacer(1, 4))
    story.append(image)
    story.append(Paragraph(caption, styles["CaptionCustom"]))

def main():
    if not REPORT.exists():
        raise FileNotFoundError(f"Markdown report not found: {REPORT}")

    text = REPORT.read_text(encoding="utf-8").splitlines()

    doc = SimpleDocTemplate(
        str(OUTPUT),
        pagesize=A4,
        rightMargin=20 * mm,
        leftMargin=20 * mm,
        topMargin=20 * mm,
        bottomMargin=22 * mm,
        title="ReliefData: Humanitarian Warehouse and Distribution Analysis",
        author="ReliefData Portfolio Project",
    )

    story = []
    first_heading = True
    in_table = False
    table_lines = []

    def flush_table():
        nonlocal table_lines
        if not table_lines:
            return

        rows = []
        for line in table_lines:
            cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
            if all(re.fullmatch(r":?-{3,}:?", c) for c in cells):
                continue
            rows.append([
                Paragraph(inline_markup(cell), styles["BodyCustom"])
                for cell in cells
            ])

        if rows:
            tbl = Table(rows, repeatRows=1, hAlign="LEFT")
            tbl.setStyle(TableStyle([
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#D9EAF7")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.HexColor("#17365D")),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("GRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#C7D0D9")),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (-1, -1), 5),
                ("RIGHTPADDING", (0, 0), (-1, -1), 5),
                ("TOPPADDING", (0, 0), (-1, -1), 4),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
            ]))
            story.append(tbl)
            story.append(Spacer(1, 8))
        table_lines = []

    for line in text:
        stripped = line.strip()

        if stripped.startswith("|") and stripped.endswith("|"):
            in_table = True
            table_lines.append(stripped)
            continue
        elif in_table:
            flush_table()
            in_table = False

        if not stripped:
            continue

        if stripped.startswith("# "):
            title = stripped[2:].strip()
            if first_heading:
                story.append(Spacer(1, 25 * mm))
                story.append(Paragraph(escape(title), styles["ReportTitle"]))
                story.append(Spacer(1, 8))
                first_heading = False
            else:
                story.append(Paragraph(inline_markup(title), styles["SectionHeading"]))
            continue

        if stripped.startswith("## "):
            story.append(Paragraph(
                inline_markup(stripped[3:].strip()),
                styles["SectionHeading"],
            ))
            continue

        if stripped.startswith("### "):
            story.append(Paragraph(
                inline_markup(stripped[4:].strip()),
                styles["SubHeading"],
            ))
            continue

        if stripped.startswith("!["):
            match = re.match(r"!\[(.*?)\]\((.*?)\)", stripped)
            if match:
                alt, filename = match.groups()
                if filename in CHARTS:
                    add_chart(story, filename, alt)
            continue

        if stripped.startswith("*") and stripped.endswith("*") and not stripped.startswith("**"):
            story.append(Paragraph(
                inline_markup(stripped.strip("*")),
                styles["CaptionCustom"],
            ))
            continue

        if stripped.startswith("- "):
            story.append(Paragraph(
                "• " + inline_markup(stripped[2:]),
                styles["BulletCustom"],
            ))
            continue

        if re.match(r"^\d+\.\s", stripped):
            item = re.sub(r"^\d+\.\s", "", stripped)
            story.append(Paragraph(
                "• " + inline_markup(item),
                styles["BulletCustom"],
            ))
            continue

        if stripped.startswith("**") and ":**" in stripped:
            story.append(Paragraph(inline_markup(stripped), styles["BodyCustom"]))
            continue

        story.append(Paragraph(inline_markup(stripped), styles["BodyCustom"]))

    if in_table:
        flush_table()

    doc.build(story, onFirstPage=footer, onLaterPages=footer)
    print(f"PDF created: {OUTPUT}")
    print(f"Size: {OUTPUT.stat().st_size:,} bytes")

if __name__ == "__main__":
    main()
