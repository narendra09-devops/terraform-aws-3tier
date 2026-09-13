#!/usr/bin/env python3
"""Generate the one-page architecture poster shipped with the repository."""

from pathlib import Path

from reportlab.lib.colors import HexColor, white
from reportlab.lib.pagesizes import A3, landscape
from reportlab.pdfbase.pdfmetrics import stringWidth
from reportlab.pdfgen import canvas


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "diagrams" / "aws-3tier-architecture-poster.pdf"
W, H = landscape(A3)

NAVY = HexColor("#16233A")
INK = HexColor("#24324A")
MUTED = HexColor("#64748B")
ORANGE = HexColor("#FF9900")
BLUE = HexColor("#DDEEFF")
BLUE_DARK = HexColor("#2563EB")
GREEN = HexColor("#DCFCE7")
GREEN_DARK = HexColor("#15803D")
PURPLE = HexColor("#F1E8FF")
PURPLE_DARK = HexColor("#7C3AED")
PALE = HexColor("#F8FAFC")
LINE = HexColor("#CBD5E1")


def centered(c, text, x, y, width, font="Helvetica-Bold", size=11, color=INK):
    c.setFont(font, size)
    c.setFillColor(color)
    c.drawString(x + (width - stringWidth(text, font, size)) / 2, y, text)


def box(c, x, y, width, height, title, subtitle, fill, stroke, radius=9):
    c.setFillColor(fill)
    c.setStrokeColor(stroke)
    c.setLineWidth(1.5)
    c.roundRect(x, y, width, height, radius, fill=1, stroke=1)
    centered(c, title, x, y + height / 2 + 3, width, size=11, color=INK)
    centered(c, subtitle, x, y + height / 2 - 13, width, font="Helvetica", size=8.2, color=MUTED)


def arrow(c, x1, y1, x2, y2, color=ORANGE, width=2):
    c.setStrokeColor(color)
    c.setFillColor(color)
    c.setLineWidth(width)
    c.line(x1, y1, x2, y2)
    if abs(y2 - y1) >= abs(x2 - x1):
        direction = 1 if y2 > y1 else -1
        c.line(x2, y2, x2 - 5, y2 - 8 * direction)
        c.line(x2, y2, x2 + 5, y2 - 8 * direction)
    else:
        direction = 1 if x2 > x1 else -1
        c.line(x2, y2, x2 - 8 * direction, y2 - 5)
        c.line(x2, y2, x2 - 8 * direction, y2 + 5)


def pill(c, x, y, text, fill, color=INK):
    size = 8.5
    width = stringWidth(text, "Helvetica-Bold", size) + 22
    c.setFillColor(fill)
    c.setStrokeColor(fill)
    c.roundRect(x, y, width, 22, 11, fill=1, stroke=0)
    centered(c, text, x, y + 7, width, size=size, color=color)
    return width


def draw():
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    c = canvas.Canvas(str(OUTPUT), pagesize=(W, H))
    c.setTitle("Production 3-Tier AWS Infrastructure")
    c.setAuthor("Narendra Singh")

    c.setFillColor(NAVY)
    c.rect(0, H - 92, W, 92, fill=1, stroke=0)
    c.setFillColor(ORANGE)
    c.rect(0, H - 98, W, 6, fill=1, stroke=0)
    c.setFillColor(white)
    c.setFont("Helvetica-Bold", 28)
    c.drawString(48, H - 52, "Production 3-Tier AWS Infrastructure")
    c.setFont("Helvetica", 12)
    c.drawString(49, H - 74, "Secure • Highly available • Reproducible with Terraform")
    c.setFont("Helvetica-Bold", 10)
    c.drawRightString(W - 48, H - 57, "PORTFOLIO ARCHITECTURE")

    c.setFillColor(PALE)
    c.roundRect(35, 65, 805, 650, 16, fill=1, stroke=0)
    c.setStrokeColor(LINE)
    c.setLineWidth(1.5)
    c.roundRect(55, 105, 765, 465, 14, fill=0, stroke=1)
    c.setFillColor(NAVY)
    c.setFont("Helvetica-Bold", 12)
    c.drawString(70, 548, "VPC 10.30.0.0/16  •  eu-central-1  •  Two Availability Zones")

    box(c, 306, 655, 220, 46, "Users / Internet", "Public HTTPS requests", white, LINE)
    box(c, 326, 594, 180, 42, "Amazon Route 53", "DNS alias", BLUE, BLUE_DARK)
    arrow(c, 416, 655, 416, 636)
    arrow(c, 416, 594, 416, 566)

    c.setFillColor(HexColor("#FFF7E6"))
    c.roundRect(70, 437, 735, 100, 10, fill=1, stroke=0)
    c.setFillColor(ORANGE)
    c.setFont("Helvetica-Bold", 10)
    c.drawString(82, 516, "PUBLIC TIER")
    box(c, 322, 465, 230, 48, "Application Load Balancer", "HTTPS :443 • HTTP redirect • S3 logs", white, ORANGE)
    box(c, 96, 455, 145, 42, "NAT Gateway A", "Outbound access", white, ORANGE)
    box(c, 634, 455, 145, 42, "NAT Gateway B", "Outbound access", white, ORANGE)

    c.setFillColor(BLUE)
    c.roundRect(70, 302, 735, 115, 10, fill=1, stroke=0)
    c.setFillColor(BLUE_DARK)
    c.setFont("Helvetica-Bold", 10)
    c.drawString(82, 396, "PRIVATE APPLICATION TIER")
    box(c, 120, 330, 205, 48, "EC2 Application A", "Private IP • IMDSv2 • SSM", white, BLUE_DARK)
    box(c, 550, 330, 205, 48, "EC2 Application B", "Private IP • IMDSv2 • SSM", white, BLUE_DARK)
    centered(c, "AUTO SCALING GROUP  •  HEALTH-BASED REPLACEMENT  •  CPU TARGET TRACKING", 190, 309, 495, size=8.5, color=BLUE_DARK)
    arrow(c, 390, 465, 230, 378, BLUE_DARK)
    arrow(c, 484, 465, 652, 378, BLUE_DARK)

    c.setFillColor(GREEN)
    c.roundRect(70, 137, 735, 145, 10, fill=1, stroke=0)
    c.setFillColor(GREEN_DARK)
    c.setFont("Helvetica-Bold", 10)
    c.drawString(82, 260, "ISOLATED DATABASE TIER")
    box(c, 150, 178, 210, 52, "RDS MySQL Primary", "Writer endpoint • encrypted • backups", white, GREEN_DARK)
    box(c, 515, 178, 210, 52, "RDS Standby", "Multi-AZ synchronous standby", white, GREEN_DARK)
    arrow(c, 255, 330, 255, 230, GREEN_DARK)
    arrow(c, 652, 330, 350, 230, GREEN_DARK)
    arrow(c, 360, 204, 515, 204, GREEN_DARK)

    c.setStrokeColor(LINE)
    c.setDash(4, 3)
    c.line(437, 137, 437, 537)
    c.setDash()
    pill(c, 82, 110, "AVAILABILITY ZONE A", HexColor("#E2E8F0"))
    pill(c, 574, 110, "AVAILABILITY ZONE B", HexColor("#E2E8F0"))

    c.setFillColor(white)
    c.setStrokeColor(LINE)
    c.roundRect(865, 65, 290, 650, 16, fill=1, stroke=1)
    c.setFillColor(NAVY)
    c.setFont("Helvetica-Bold", 16)
    c.drawString(888, 680, "Security & operations")
    c.setFillColor(MUTED)
    c.setFont("Helvetica", 9)
    c.drawString(888, 663, "Cross-cutting controls for every tier")

    cards = [
        ("IAM + Session Manager", "No inbound SSH; scoped instance role", BLUE, BLUE_DARK),
        ("KMS + Secrets Manager", "EBS, S3, RDS, logs and credentials", PURPLE, PURPLE_DARK),
        ("Amazon S3", "Application data + ALB audit logs", HexColor("#E8F8EC"), GREEN_DARK),
        ("CloudWatch + SNS", "Logs, dashboard, metrics and alerts", HexColor("#FFF1E8"), ORANGE),
        ("Terraform remote state", "Versioned S3 state + native lock file", BLUE, BLUE_DARK),
        ("GitHub Actions OIDC", "fmt • validate • TFLint • Checkov • plan", PURPLE, PURPLE_DARK),
    ]
    y = 600
    for title, subtitle, fill, stroke in cards:
        box(c, 888, y, 244, 54, title, subtitle, fill, stroke)
        y -= 72

    c.setFillColor(NAVY)
    c.roundRect(888, 128, 244, 64, 9, fill=1, stroke=0)
    centered(c, "CHANGE CONTROL", 888, 166, 244, size=9, color=ORANGE)
    centered(c, "Plan → approval → exact apply", 888, 146, 244, font="Helvetica", size=10, color=white)

    c.setFillColor(MUTED)
    c.setFont("Helvetica", 8.5)
    c.drawString(50, 35, "Traffic: Route 53 → HTTPS ALB → private EC2 Auto Scaling → isolated Multi-AZ RDS")
    c.drawRightString(W - 50, 35, "Narendra Singh  •  AWS / Terraform portfolio project")
    c.save()


if __name__ == "__main__":
    draw()
    print(OUTPUT)
